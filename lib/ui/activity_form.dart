import 'package:activities/controller/activities_controller.dart';
import 'package:activities/model/activities_model.dart';
import 'package:activities/widget/button.dart';
import 'package:activities/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:intl/intl.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({Key key, this.data, this.controller}) : super(key: key);
  final ActivityModel data;
  final ActivitiesController controller;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final List<String> activityType = ["Meeting", "Phone Call"];
  final List<String> objective = ["New Order", "Invoice", "New Leads"];
  final _formKey = GlobalKey<FormState>();
  ActivityModel activityModel = ActivityModel();

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    if (widget.data != null) {
      activityModel = widget.data;
      setState(() {});
    }
  }

  Widget activityTypeWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What do you want to do ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]),
                    ),
                  ),
                  validator: (value) {
                    if (activityModel.activityType == null) {
                      return 'Field Required';
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  value: activityModel.activityType,
                  hint: const Text(
                    "Meeting or Calling",
                    style: TextStyle(color: Colors.grey),
                  ),
                  items: activityType
                      .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      activityModel.activityType = value;
                    });
                  }),
            ),
          ],
        ),
      );

  Widget institutionWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Who do you want to meet or call ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                key: Key(activityModel.institution ?? ''),
                initialValue: activityModel.institution,
                onChanged: (value) => activityModel.institution = value,
                validator: (value) =>
                    activityModel.institution == null ? 'Field Required' : null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    hintText: 'CV Anugerah Jaya',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300],
                      ),
                    ),
                    suffixIcon: const Icon(Icons.search)),
              ),
            ),
          ],
        ),
      );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: activityModel.when ?? DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (dateTime != null) {
      _selectTime(dateTime);
    }
  }

  Future<void> _selectTime(DateTime date) async {
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: date.hour, minute: date.minute),
    );
    if (time != null) {
      DateTime dateTime;
      dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      activityModel.when = dateTime;
      setState(() {});
    }
  }

  Widget dateWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('When do you want to meet or call ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  enabled: false,
                  validator: (value) =>
                      activityModel.when == null ? 'Field Required' : null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red),
                      hintText: activityModel.when != null
                          ? DateFormat('dd-MMM-yyyy HH:mm')
                              .format(activityModel.when)
                          : 'dd-MMM-yyyy HH:mm',
                      hintStyle: TextStyle(
                          color: activityModel.when != null
                              ? Colors.black
                              : Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[300],
                        ),
                      ),
                      suffixIcon: const Icon(Icons.calendar_month)),
                ),
              ),
            ),
          ],
        ),
      );

  Widget objectiveWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why do you want to meet or call ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]),
                    ),
                  ),
                  validator: (value) {
                    if (activityModel.objective == null) {
                      return 'Field Required';
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  value: activityModel.objective,
                  hint: const Text(
                    "New Order, Invoice, New Leads",
                    style: TextStyle(color: Colors.grey),
                  ),
                  items: objective
                      .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      activityModel.objective = value;
                    });
                  }),
            ),
          ],
        ),
      );

  Widget descriptionWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Could you describe it more details ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                key: Key(activityModel.remarks ?? ''),
                initialValue: activityModel.remarks,
                maxLines: 5,
                onChanged: (value) => activityModel.remarks = value,
                validator: (value) =>
                    activityModel.remarks == null ? 'Field Required' : null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    hintText: 'Placeholder',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey[300],
                      ),
                    )),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CustomAppBar(
                  isBack: true,
                  height: MediaQuery.of(context).size.height * 0.15,
                  title:
                      widget.data == null ? 'New Activity' : 'Edit Activity'),
              Expanded(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      activityTypeWidget(),
                      institutionWidget(),
                      dateWidget(),
                      objectiveWidget(),
                      descriptionWidget(),
                      const SizedBox(height: 30),
                      ButtonWidget(
                        callBack: () async {
                          if (_formKey.currentState.validate()) {
                            bool successSave = await showDialog(
                              context: context,
                              builder: (context) => FutureProgressDialog(
                                widget.data == null
                                    ? widget.controller
                                        .saveActivity(activityModel)
                                    : widget.controller
                                        .editActivity(activityModel),
                                message: const Text('Save Activity'),
                              ),
                            );
                            if (successSave) {
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Failed Save New Activity');
                            }
                          }
                        },
                        text: 'Submit',
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
