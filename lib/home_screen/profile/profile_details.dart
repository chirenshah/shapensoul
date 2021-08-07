import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersns/home_screen/appointment/previous_appoint.dart';
// import 'package:fluttersns/name2phone.dart';
import '../diet/edit_diet.dart';
import 'package:intl/intl.dart';

class ProfileDetails extends StatefulWidget {
  final String name;
  ProfileDetails({Key key, @required this.name}) : super(key: key);

  @override
  _ProfileDetails createState() => new _ProfileDetails();
}

class _ProfileDetails extends State<ProfileDetails> {
  String _weightController = '';
  String _tongue = '';
  String _bp = '';
  String _history = '';
  String _symptoms = '';
  String _medication = '';
  String phone;
  final _formkey = GlobalKey<FormState>();
  Map<String, dynamic> diet;

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  getDetails() {
    print(widget.name);
    phone = widget.name;
    var data;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.name)
        .get()
        .then((value) => {
              data = value.data(),
              _medication = data['diagnosis']['medication'],
              _weightController = data['personal']['weight'],
              _bp = data['personal']['Bloodpressure'],
              diet = data['diet'],
              _history = data['personal']['history'],
              _symptoms = data['personal']['Symptoms'],
            })
        .catchError((onError) {
      print(onError);
    });
  }

  Future<void> updateUser() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .update({
          'personal.weight': _weightController,
          'personal.Bloodpressure': _bp,
          'personal.medication': _medication,
          'personal.history': _history,
          'personal.Symptoms': _symptoms,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  toTime(t) {
    final now = new DateTime.now();
    t = TimeOfDay(
        hour: int.parse(t.split(":")[0]), minute: int.parse(t.split(":")[1]));
    var d = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    String formattedTime = DateFormat('h:mm a').format(d);
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.name;

    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Users');
    return FutureBuilder<DocumentSnapshot>(
        future: appointment.doc(name).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Scaffold(
                body: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.all(25),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(data['name'],
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 30,
                                )),
                          ),
                          Flexible(
                            child: Text(
                              data['personal']['phone'],
                              style: TextStyle(
                                  // color: Colors.green[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xffffffff),
                              Color(0xccEBFCE5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    floating: true,
                    pinned: false,
                    elevation: 9,
                    expandedHeight: 200,
                    actions: <Widget>[
                      PopupMenuButton(
                        elevation: 3,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: Text('View Previous Appointments'))
                        ],
                        offset: Offset(0, 45),
                        onSelected: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PrevAppoint(name: data['name']),
                              ));
                        },
                      )
                    ],
                  ),
                  Form(
                    key: _formkey,
                    child: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 26, 0, 1),
                            child: Text(
                              'Personal Details',
                              style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green[900]),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(23, 16, 10, 16),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text("Medication : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500)),
                                    Expanded(
                                      child: Card(
                                        color: Color(0xffFBFDFB),
                                        elevation: 0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: _medication,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueGrey[600],
                                                      fontSize: 19.0,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  cursorColor: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Text("Weight : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500)),
                                    Expanded(
                                      child: Card(
                                        color: Color(0xffFBFDFB),
                                        elevation: 0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.blueGrey[600],
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500),
                                            keyboardType:
                                                TextInputType.multiline,
                                            cursorColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Text("Blood Pressure : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500)),
                                    Expanded(
                                      child: Card(
                                        color: Color(0xffFBFDFB),
                                        elevation: 0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.blueGrey[600],
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500),
                                            keyboardType:
                                                TextInputType.multiline,
                                            cursorColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Text("History : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500)),
                                    Expanded(
                                      child: Card(
                                        color: Color(0xffFBFDFB),
                                        elevation: 0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextFormField(
                                            initialValue: _history,
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.blueGrey[600],
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500),
                                            cursorColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  Row(children: [
                                    Text("Symptoms : ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500)),
                                    Expanded(
                                      child: Card(
                                        color: Color(0xffFBFDFB),
                                        elevation: 0.2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none),
                                            initialValue: _symptoms,
                                            style: TextStyle(
                                                color: Colors.blueGrey[600],
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w500),
                                            keyboardType:
                                                TextInputType.multiline,
                                            cursorColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 12, 12, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();

                                              updateUser();
                                            },
                                            child: Text(
                                              "Save Changes",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                        offset:
                                                            Offset(0.5, 0.5),
                                                        blurRadius: 2.0,
                                                        color: Colors
                                                            .blueGrey[100]),
                                                  ],
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 3, 0, 3),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Diet',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green[900]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: new IconButton(
                                      icon: Icon(Icons.add),
                                      color: Colors.green[900],
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AddDiet(
                                                        title: jsonEncode({
                                                      'phone': phone,
                                                      'time': '',
                                                      'recipe': ''
                                                    }))));
                                      },
                                      tooltip: "Add Diet"),
                                )
                              ],
                            ),
                          ),
                          if (data['diet'] != null)
                            for (var method
                                in data['diet'].keys.toList()..sort())
                              Column(
                                children: [
                                  Card(
                                    color: Color(0xffFBFDFB),
                                    elevation: 0.2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: IntrinsicHeight(
                                        child: Row(children: [
                                          Text(
                                            toTime(method),
                                            style: TextStyle(
                                                color: Colors.blueGrey[800],
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          VerticalDivider(
                                            width: 35,
                                            thickness: 0.4,
                                            color: Colors.blueGrey[100],
                                          ),
                                          Text(
                                            data['diet'][method],
                                            style: TextStyle(
                                                color: Colors.green[800],
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          IconButton(
                                            color: Colors.grey,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddDiet(
                                                              title:
                                                                  jsonEncode({
                                                            'phone': phone,
                                                            'time': method,
                                                            'recipe':
                                                                data['diet']
                                                                    [method]
                                                          }))));
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                          IconButton(
                                            color: Colors.grey,
                                            onPressed: () {
                                              showAlertDialog(context, method);
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
          }
          return Container();
        });
  }

  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
        child: Text(
          "Yes",
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          delete(message);
          setState(() {});
          Navigator.of(context).pop();
        });

    AlertDialog alert = AlertDialog(
        title: const Text(
          "Delete",
          style: TextStyle(fontSize: 21),
        ),
        content: Text(
          'Are you sure ?',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          cancelButton,
          continueButton,
        ]);
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void delete(time) {
    diet.remove(time);
    FirebaseFirestore.instance
        .collection('Users')
        .doc(phone)
        .update({'diet': diet});
  }
}
