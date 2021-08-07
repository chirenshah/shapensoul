import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Diet extends StatefulWidget {
  final Map<String, dynamic> data;
  Diet({Key key, @required this.data}) : super(key: key);

  @override
  _DietState createState() => _DietState();
}

class _DietState extends State<Diet> {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController1 = TextEditingController();
  TextEditingController _timeController2 = TextEditingController();
  TextEditingController _timeController3 = TextEditingController();
  TextEditingController _timeController4 = TextEditingController();
  TextEditingController _timeController5 = TextEditingController();
  TextEditingController _timeController6 = TextEditingController();
  List<String> diet = [];
  SimpleAutoCompleteTextField _dietController1;
  GlobalKey<AutoCompleteTextFieldState<String>> dietkey1 = new GlobalKey();
  String selecteddiet1 = "";
  String diettext1;
  SimpleAutoCompleteTextField _dietController2;
  SimpleAutoCompleteTextField _dietController3;
  SimpleAutoCompleteTextField _dietController4;
  SimpleAutoCompleteTextField _dietController5;
  SimpleAutoCompleteTextField _dietController6;
  GlobalKey<AutoCompleteTextFieldState<String>> dietkey2 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> dietkey3 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> dietkey4 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> dietkey5 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> dietkey6 = new GlobalKey();
  String selecteddiet2 = "";
  String selecteddiet3 = "";
  String selecteddiet4 = "";
  String selecteddiet5 = "";
  String selecteddiet6 = "";
  String diettext2;
  String diettext3;
  String diettext4;
  double _width;

  final _formkey = GlobalKey<FormState>();

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
  void initState() {
    auto();
    super.initState();
  }

  _DietState() {
    _dietController1 = SimpleAutoCompleteTextField(
        key: dietkey1,
        decoration: new InputDecoration(labelText: "Recipe Name"),
        controller: TextEditingController(text: ""),
        suggestions: diet,
        textChanged: (text) => diettext1 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selecteddiet1 = text;
              }
            }));
    _dietController2 = SimpleAutoCompleteTextField(
        key: dietkey2,
        decoration: new InputDecoration(labelText: "Recipe Name"),
        controller: TextEditingController(text: ""),
        suggestions: diet,
        textChanged: (text) => diettext1 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selecteddiet2 = text;
              }
            }));
    _dietController3 = SimpleAutoCompleteTextField(
        key: dietkey3,
        decoration: new InputDecoration(labelText: "Recipe Name"),
        controller: TextEditingController(text: ""),
        suggestions: diet,
        textChanged: (text) => diettext3 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selecteddiet3 = text;
              }
            }));
    _dietController4 = SimpleAutoCompleteTextField(
        key: dietkey4,
        decoration: new InputDecoration(labelText: "Recipe Name"),
        controller: TextEditingController(text: ""),
        suggestions: diet,
        textChanged: (text) => diettext4 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selecteddiet4 = text;
              }
            }));
    _dietController5 = SimpleAutoCompleteTextField(
        key: dietkey5,
        decoration: new InputDecoration(labelText: "Recipe Name"),
        controller: TextEditingController(text: ""),
        suggestions: diet,
        textChanged: (text) => diettext4 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selecteddiet5 = text;
              }
            }));
    _dietController6 = SimpleAutoCompleteTextField(
        key: dietkey6,
        decoration: new InputDecoration(labelText: "Recipe Name"),
        controller: TextEditingController(text: ""),
        suggestions: diet,
        textChanged: (text) => diettext4 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selecteddiet6 = text;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> dietData = {};
    return Scaffold(
        appBar: AppBar(title: Text("Suggested Diet")),
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
                          child: _dietController1),
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
                          child: _dietController2),
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
                          child: _dietController3),
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
                          child: _dietController4),
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
                          child: _dietController5),
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
                          child: _dietController6),
                    )
                  ]),
                  Center(
                      child: Padding(
                    child: ElevatedButton(
                        onPressed: () {
                          if (selecteddiet1 != "") {
                            setState(() {
                              dietData[_timeController1.text] = selecteddiet1;
                              dietData[_timeController2.text] = selecteddiet2;
                              dietData[_timeController3.text] = selecteddiet3;
                              dietData[_timeController4.text] = selecteddiet4;
                              dietData[_timeController5.text] = selecteddiet5;
                              dietData[_timeController6.text] = selecteddiet6;
                            });
                          }
                          widget.data["diet"] = dietData;
                          print(widget.data);
                          if (widget.data['name'] != null) {
                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc("+91" + widget.data['personal']["phone"])
                                .set({...widget.data}).then((something) {
                              print(widget.data["name"]);
                              FirebaseFirestore.instance
                                  .collection("Names")
                                  .doc(widget.data["name"])
                                  .set({
                                "phone":
                                    '+91' + widget.data['personal']["phone"],
                              });
                            }).catchError((onError) {
                              print(onError);
                            });
                          } else {
                            showAlertDialog(context);
                          }
                        },
                        child: Text("Create User")),
                    padding: EdgeInsets.all(10),
                  ))
                ]))));
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = Center(
        child: ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(child: Text("Error")),
      content: Text("Please enter User's Name and Phone Number"),
      actions: [
        okButton,
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

  void auto() {
    FirebaseFirestore.instance
        .collection('Recipe')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                diet.add(doc.data()["Name"]);
              }),
            })
        .catchError((e) {
      Navigator.of(context).pop();
    });
  }
}
