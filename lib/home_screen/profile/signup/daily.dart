import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class DailySchedule extends StatefulWidget {
  final Map<String, dynamic> data;
  DailySchedule({Key key, @required this.data}) : super(key: key);
  @override
  _DailyScheduleState createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController1 = TextEditingController();
  TextEditingController _timeController2 = TextEditingController();
  TextEditingController _timeController3 = TextEditingController();
  TextEditingController _timeController4 = TextEditingController();
  TextEditingController _timeController5 = TextEditingController();
  TextEditingController _timeController6 = TextEditingController();
  double _width;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.data != null) {
      print(widget.data.keys);
    }
    super.initState();
  }

  Future<Null> _selectTime(
      BuildContext context, TextEditingController time) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        time.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    Map<String, String> dailySchedule = {};
    return Scaffold(
        appBar: AppBar(title: Text("Daily Schedule")),
        body: SingleChildScrollView(
            child: Form(
                key: _formkey,
                child: Wrap(runSpacing: 50, children: [
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _selectTime(context, _timeController1);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 50, 0),
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.watch_later),
                                    hintText: 'Select Time',
                                    labelText: 'Time',
                                  ),
                                  controller: _timeController1,
                                ),
                              ),
                            ))),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Activity",
                                labelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                            onSaved: (value) {
                              dailySchedule[_timeController1.text] = value;
                            },
                          )),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _selectTime(context, _timeController2);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 50, 0),
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.watch_later),
                                    hintText: 'Select Time',
                                    labelText: 'Time',
                                  ),
                                  controller: _timeController2,
                                ),
                              ),
                            ))),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Activity",
                                labelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                            onSaved: (value) {
                              dailySchedule[_timeController2.text] = value;
                            },
                          )),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _selectTime(context, _timeController3);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 50, 0),
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.watch_later),
                                    hintText: 'Select Time',
                                    labelText: 'Time',
                                  ),
                                  controller: _timeController3,
                                ),
                              ),
                            ))),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Activity",
                                labelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                            onSaved: (value) {
                              dailySchedule[_timeController3.text] = value;
                            },
                          )),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _selectTime(context, _timeController4);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 50, 0),
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.watch_later),
                                    hintText: 'Select Time',
                                    labelText: 'Time',
                                  ),
                                  controller: _timeController4,
                                ),
                              ),
                            ))),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Activity",
                                labelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                            onSaved: (value) {
                              dailySchedule[_timeController4.text] = value;
                            },
                          )),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _selectTime(context, _timeController5);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 50, 0),
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.watch_later),
                                    hintText: 'Select Time',
                                    labelText: 'Time',
                                  ),
                                  controller: _timeController5,
                                ),
                              ),
                            ))),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Activity",
                                labelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                            onSaved: (value) {
                              dailySchedule[_timeController5.text] = value;
                            },
                          )),
                    )
                  ]),
                  Row(children: [
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              _selectTime(context, _timeController6);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 50, 0),
                              child: IgnorePointer(
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: const Icon(Icons.watch_later),
                                    hintText: 'Select Time',
                                    labelText: 'Time',
                                  ),
                                  controller: _timeController6,
                                ),
                              ),
                            ))),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: "Activity",
                                labelStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w300)),
                            onSaved: (value) {
                              dailySchedule[_timeController6.text] = value;
                            },
                          )),
                    )
                  ]),
                  Center(
                      child: Padding(
                    child: ElevatedButton(
                        onPressed: () {
                          _formkey.currentState.save();
                          if (dailySchedule[_timeController1.text] != "") {
                            widget.data['daily'] = dailySchedule;
                          }
                        },
                        child: Text("Save")),
                    padding: EdgeInsets.all(10),
                  ))
                ]))));
  }
}
