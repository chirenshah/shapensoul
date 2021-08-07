import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Treatment extends StatefulWidget {
  final Map<String, dynamic> data;
  Treatment({Key key, @required this.data}) : super(key: key);

  @override
  _TreatmentState createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  List<String> therapy = [];
  SimpleAutoCompleteTextField _therapyController1;
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey1 = new GlobalKey();
  String selectedTherapy1 = "";
  String therapytext1;
  SimpleAutoCompleteTextField _therapyController2;
  SimpleAutoCompleteTextField _therapyController3;
  SimpleAutoCompleteTextField _therapyController4;
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey2 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey3 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> therapykey4 = new GlobalKey();
  String selectedTherapy2 = "";
  String selectedTherapy3 = "";
  String selectedTherapy4 = "";
  String therapytext2;
  String therapytext3;
  String therapytext4;
  double _width;
  double _height;

  @override
  void initState() {
    auto();
    super.initState();
  }

  _TreatmentState() {
    _therapyController1 = SimpleAutoCompleteTextField(
        key: therapykey1,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Therapy Name"),
        controller: TextEditingController(text: ""),
        suggestions: therapy,
        textChanged: (text) => therapytext1 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy1 = text;
              }
            }));
    _therapyController2 = SimpleAutoCompleteTextField(
        key: therapykey2,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Therapy Name"),
        controller: TextEditingController(text: ""),
        suggestions: therapy,
        textChanged: (text) => therapytext2 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy2 = text;
              }
            }));
    _therapyController3 = SimpleAutoCompleteTextField(
        key: therapykey3,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Therapy Name"),
        controller: TextEditingController(text: ""),
        suggestions: therapy,
        textChanged: (text) => therapytext3 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy3 = text;
              }
            }));
    _therapyController4 = SimpleAutoCompleteTextField(
        key: therapykey4,
        decoration: new InputDecoration(
            icon: const Icon(Icons.assignment), labelText: "Therapy Name"),
        controller: TextEditingController(text: ""),
        suggestions: therapy,
        textChanged: (text) => therapytext4 = text,
        clearOnSubmit: false,
        textSubmitted: (text) => setState(() {
              if (text != "") {
                selectedTherapy4 = text;
              }
            }));
  }
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    List<String> treatment = [];
    return Scaffold(
        appBar: AppBar(title: Text("Suggested Treatments")),
        body: Container(
            // height: _height,
            child: Wrap(children: [
          Padding(
            child: Container(child: _therapyController1, width: _width * 0.9),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          Padding(
            child: Container(child: _therapyController2, width: _width * 0.9),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          Padding(
            child: Container(child: _therapyController3, width: _width * 0.9),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          Padding(
            child: Container(child: _therapyController4, width: _width * 0.9),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          Padding(
            child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        treatment.addAll([
                          selectedTherapy1,
                          selectedTherapy2,
                          selectedTherapy3,
                          selectedTherapy4,
                        ]);
                      });
                      widget.data['treatment'] = treatment;
                      print(widget.data);
                    },
                    child: Text("Save"))),
            padding: EdgeInsets.all(20),
          )
        ])));
  }

  void auto() {
    FirebaseFirestore.instance
        .collection('Therapy')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                therapy.add(doc.data()["Name"]);
              }),
            })
        .catchError((e) {
      print(e);
    });
  }
}
