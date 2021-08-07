import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../name2phone.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditAppointment extends StatefulWidget {
  EditAppointment({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EditAppointmentState createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  double _height;
  double _width;
  // String _setTime, _setDate;

  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now().weekday == 7
      ? DateTime.now().add(Duration(days: 1))
      : DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  List<String> suggestions = [];
  List<String> therapy = [];
  String name;
  String therapyName;
  String therapytext = '';
  String currentText = "";
  String selected = "";
  String selectedTherapy = "";
  Timestamp date;
  var data;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _therapy = TextEditingController();
  SimpleAutoCompleteTextField _nameController;
  SimpleAutoCompleteTextField _therapyController;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey = new GlobalKey();

  @override
  void initState() {
    data = jsonDecode(widget.title);
    _name.text = data['client name'];
    _therapy.text = data['therapy name'];
    _dateController.text = data['date'];
    _timeController.text = data['time'];
    auto();
    super.initState();
  }

  _EditAppointmentState() {
    _nameController = SimpleAutoCompleteTextField(
        key: key,
        decoration: new InputDecoration(
            icon: const Icon(Icons.person), labelText: "Name"),
        controller: _name,
        suggestions: suggestions,
        textChanged: (text) => currentText = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selected = text;
              }
            }));
    _therapyController = SimpleAutoCompleteTextField(
        key: therapykey,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Therapy Name"),
        controller: _therapy,
        suggestions: therapy,
        textChanged: (text) => therapytext = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy = text;
              }
            }));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate.weekday == 7
          ? DateTime.now().add(Duration(days: 1))
          : DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(2101),
      helpText: 'SELECT APPOINTMENT DATE',
      confirmText: 'OK',
      selectableDayPredicate: (DateTime val) => val.weekday == 7 ? false : true,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMMMd().format(DateTime.now());

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    // CollectionReference names = FirebaseFirestore.instance.collection('Names');
    CollectionReference appt =
        FirebaseFirestore.instance.collection('Appointments');

    String apptName = _dateController.text + ' ' + _timeController.text;
    DateTime duration = DateFormat('hh:mm aaa').parse(_timeController.text);
    selectedDate =
        new DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    selectedDate = selectedDate
        .add(new Duration(hours: duration.hour, minutes: duration.minute));
    date = Timestamp.fromDate(selectedDate);

    void showErrorDialog(BuildContext context, String message) {
      // set up the AlertDialog
      final CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text('\n$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Future<void> addAppt() async {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      if (selected == '') {
        selected = _name.text;
      }
      if (selectedTherapy == '') {
        selectedTherapy = _therapy.text;
      }

      var userphone = await name2phone(selected);
      print(data['date'] + ' ' + data['time']);
      FirebaseFirestore.instance
          .collection('Appointments')
          .doc(userphone)
          .update({
        data['date'] + ' ' + data['time']: FieldValue.delete()
      }).catchError((error) {
        print(error);
      });

      return users.get().then((querySnapshot) {
        print(querySnapshot);
        querySnapshot.docs.forEach((document) {
          print(document.data());
          batch.update(users.doc(userphone), {
            'appointment.date': date,
            'appointment.time': _timeController.text,
            'appointment.therapy name': selectedTherapy,
          });

          batch.update(appt.doc(userphone), {
            '$apptName.date': date,
            '$apptName.time': _timeController.text,
            '$apptName.therapy name': selectedTherapy,
            '$apptName.client name': selected,
          });
        });

        return batch.commit();
      }).catchError((e) {
        showErrorDialog(context, e.error);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment'),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: _width,
          height: _height,
          margin:
              const EdgeInsets.only(top: 20, left: 15, right: 40, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: _height / 40,
                  ),
                  _nameController,
                  SizedBox(
                    height: _height / 40,
                  ),
                  InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: AbsorbPointer(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.calendar_today),
                          hintText: 'Select Date',
                          labelText: 'Date',
                        ),
                        controller: _dateController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height / 40,
                  ),
                  InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child: IgnorePointer(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.watch_later),
                          hintText: 'Select Time',
                          labelText: 'Time',
                        ),
                        controller: _timeController,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height / 40,
                  ),
                  _therapyController,
                  SizedBox(
                    height: _height / 3,
                  ),
                  RaisedButton(
                    onPressed: () => {
                      addAppt(),
                      Navigator.pop(context),
                      Navigator.pushReplacementNamed(context, '/')
                    },
                    color: Colors.green[300],
                    textColor: Colors.white,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void auto() {
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                suggestions.add(doc.data()["name"]);
              }),
            })
        .catchError((e) {
      print("Got Error: {e.error}");
    });
    FirebaseFirestore.instance
        .collection('Therapy')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                therapy.add(doc.data()["Name"]);
              }),
            })
        .catchError((e) {
      print("Got Error: {e.error}");
    });
  }
}
