import 'package:activities/controller/activities_controller.dart';
import 'package:activities/model/activities_model.dart';
import 'package:activities/widget/button.dart';
import 'package:activities/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class ActivityCompleteForm extends StatefulWidget {
  const ActivityCompleteForm({Key key, this.data, this.controller})
      : super(key: key);
  final ActivityModel data;
  final ActivitiesController controller;

  @override
  State<ActivityCompleteForm> createState() => _ActivityCompleteFormState();
}

class _ActivityCompleteFormState extends State<ActivityCompleteForm> {
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

  Widget descriptionWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Details ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  TextFormField(
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
                  ButtonWidget(
                    color: Colors.blue[700],
                    callBack: () async {
                      if (_formKey.currentState.validate()) {
                        await showDialog(
                          context: context,
                          builder: (context) => FutureProgressDialog(
                            widget.controller.editActivity(activityModel),
                            message: const Text('Edit Activity'),
                          ),
                        );
                      }
                    },
                    text: 'Edit Activity',
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget resultWidget() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What is the result ?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                key: Key(activityModel.result ?? ''),
                initialValue: activityModel.result,
                maxLines: 5,
                onChanged: (value) => activityModel.result = value,
                validator: (value) =>
                    activityModel.remarks == null ? 'Field Required' : null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    errorStyle: const TextStyle(color: Colors.red),
                    hintText: 'Result',
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
                      descriptionWidget(),
                      resultWidget(),
                      const SizedBox(height: 30),
                      ButtonWidget(
                        callBack: () async {
                          if (_formKey.currentState.validate()) {
                            activityModel.status = true;
                            bool successSave = await showDialog(
                              context: context,
                              builder: (context) => FutureProgressDialog(
                                widget.controller.editActivity(activityModel),
                                message: const Text('Complete Activity'),
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
                        text: 'Complete Activity',
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
