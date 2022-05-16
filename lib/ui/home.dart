import 'package:activities/controller/activities_controller.dart';
import 'package:activities/model/activities_model.dart';
import 'package:activities/ui/activity_complete_form.dart';
import 'package:activities/ui/activity_form.dart';
import 'package:activities/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final ActivitiesController _controller = ActivitiesController();
  @override
  void initState() {
    super.initState();
    _controller.getActivities();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget activitiesWidget(List<ActivityModel> data) => Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, dd MMM yyyy').format(data.first.when),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          DateFormat('HH:mm').format(data[index].when),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            action(data[index]);
                          },
                          child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.indigoAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                data[index].remarks,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: !data[index].status
                            ? const Text('')
                            : const Icon(
                                Icons.done,
                                color: Colors.blue,
                              ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

  action(ActivityModel data) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.edit,
                  color: Colors.amber,
                ),
                title: const Text('Edit Activity',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityForm(
                                controller: _controller,
                                data: data,
                              )));
                },
              ),
              ListTile(
                leading: const Icon(Icons.done, color: Colors.blue),
                title: const Text('Complete Activity',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityCompleteForm(
                                controller: _controller,
                                data: data,
                              )));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Activity',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => FutureProgressDialog(
                      _controller.deleteActivity(data),
                      message: const Text('Delete Activity'),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const CustomAppBar(title: 'Avtivities'),
            Container(
              color: Colors.blue[900],
              child: TabBar(
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(fontSize: 18.0),
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(
                    text: 'Open',
                  ),
                  Tab(
                    text: 'Complete',
                  ),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<List<ActivityModel>>(
                      stream: _controller.lsActivitiesStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: Text('No Data'));
                        }
                        if (snapshot.data.isEmpty) {
                          return const Center(child: Text('No Data'));
                        }
                        return activitiesWidget(snapshot.data);
                      }),
                  Container()
                ],
                controller: _tabController,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActivityForm(
                        controller: _controller,
                      )));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
