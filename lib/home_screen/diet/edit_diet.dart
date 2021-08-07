import 'dart:async';
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersns/home_screen/profile/profile_details.dart';

class AddDiet extends StatefulWidget {
  AddDiet({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddDietState createState() => _AddDietState();
}

class _AddDietState extends State<AddDiet> {
  double _height;
  double _width;
  // String _setTime, _setDate;

  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String phone;
  String time;
  String recipe;
  List<String> therapy = [];
  String therapytext = '';
  String currentText = "";
  var selected;
  String selectedTherapy = '';
  Timestamp date;
  Map<String, dynamic> diet = {};

  TextEditingController _timeController = TextEditingController();
  TextEditingController _recipe = TextEditingController();

  SimpleAutoCompleteTextField _therapyController;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey = new GlobalKey();

  _AddDietState() {
    _therapyController = SimpleAutoCompleteTextField(
        key: therapykey,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Recipe Name"),
        controller: _recipe,
        suggestions: therapy,
        textChanged: (text) => therapytext = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy = text;
              }
            }));
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
            [HH, ':', nn]).toString();
      });
  }

  @override
  void initState() {
    var data = jsonDecode(widget.title);
    phone = data['phone'];
    print(phone);
    time = data['time'];
    recipe = data['recipe'];
    _recipe.text = recipe;
    _timeController.text = time;
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

    Future<void> editDiet() async {
      if (selectedTherapy == '') {
        selectedTherapy = recipe;
      }
      if (time != '') {
        diet.remove(time);
      }
      diet[_timeController.text] = selectedTherapy;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(phone)
          .update({'diet': diet});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Diet'),
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
                            editDiet(),
                            Navigator.of(context).pop(),
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfileDetails(name: phone)),
                            )
                          },
                      color: Colors.green[300],
                      textColor: Colors.white,
                      child: Column(children: [
                        if (time == '') Text('Add') else Text('Edit'),
                      ])),
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
        .collection('Recipe')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                therapy.add(doc.data()["Name"]);
              }),
            });
    print(phone + 'something');
    FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .get()
        .then((DocumentSnapshot querySnapshot) => {
              setState(() {
                diet = querySnapshot.data()['diet'];
              })
            });
  }
}
