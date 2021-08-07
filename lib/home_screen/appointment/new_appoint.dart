import 'dart:async';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../../name2phone.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment extends StatefulWidget {
  Appointment({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
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
  String therapytext = '';
  String currentText = "";
  var selected;
  var selectedTherapy;
  Timestamp date;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  SimpleAutoCompleteTextField _nameController;
  SimpleAutoCompleteTextField _therapyController;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey = new GlobalKey();

  _AppointmentState() {
    _nameController = SimpleAutoCompleteTextField(
        key: key,
        decoration: new InputDecoration(
            icon: const Icon(Icons.person), labelText: "Name"),
        controller: TextEditingController(text: ""),
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
        controller: TextEditingController(text: ""),
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
  void initState() {
    _dateController.text = null;
    _timeController.text = null;
    auto();
    // _dateController.text = DateFormat.yMMMd().format(DateTime.now());

    // _timeController.text = formatDate(
    //     DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
    //     [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMMMd().format(DateTime.now());
    String apptName = _dateController.text + ' ' + _timeController.text;

    Future<void> addAppt() async {
      DateTime duration = DateFormat('hh:mm aaa').parse(_timeController.text);
      selectedDate = selectedDate
          .add(new Duration(hours: duration.hour, minutes: duration.minute));
      date = Timestamp.fromDate(selectedDate);
      var userphone = await name2phone(selected);
      FirebaseFirestore.instance.collection('Appointments').doc(userphone).set({
        apptName: {
          'date': date,
          'time': _timeController.text,
          'therapy name': selectedTherapy,
          'client name': selected
        }
      }, SetOptions(merge: true));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Appointment'),
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
                    child: Text('Book Appointment'),
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
              print(suggestions)
            })
        .catchError((e) {
      print(e);
    });
    FirebaseFirestore.instance
        .collection('Therapy')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                //print(doc.data()["Name"]);
                therapy.add(doc.data()["Name"]);
              }),
            })
        .catchError((e) {
      print(e);
    });
  }
}
