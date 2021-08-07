import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttersns/home_screen/profile/signup/Personal.dart';
import 'package:fluttersns/home_screen/profile/signup/daily.dart';
import 'package:fluttersns/home_screen/profile/signup/diet.dart';
import 'package:fluttersns/home_screen/profile/signup/treatment.dart';

class NewProfile extends StatefulWidget {
  @override
  _NewProfileState createState() => _NewProfileState();
}

//TODO don't reset the textcontrollers
class _NewProfileState extends State<NewProfile> {
  int _currentIndex = 0;
  Map<String, dynamic> data = {};
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  getPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return Personal(data: data);

      case 1:
        return DailySchedule(data: data);

      case 2:
        return Diagnosis(data: data);

      case 3:
        return Treatment(data: data);

      case 4:
        return Diet(data: data);

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(_currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xfff6fef6),
        height: 50,
        color: Colors.green[300],
        buttonBackgroundColor: Color(0xfff6fef6),
        animationCurve: Curves.decelerate,
        items: <Widget>[
          Icon(Icons.account_circle_outlined),
          Icon(Icons.access_time_rounded),
          Icon(Icons.accessibility_new_rounded),
          Icon(Icons.add_business_rounded),
          Icon(Icons.add_chart_outlined)
        ],
        onTap: onTabTapped,
      ),
    );
  }
}

class Diagnosis extends StatefulWidget {
  final Map<String, dynamic> data;
  Diagnosis({Key key, @required this.data}) : super(key: key);
  @override
  _DiagnosisState createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  final _formkey = GlobalKey<FormState>();
  String prakruti = '';
  String fingers = 'Fingers';
  String prana = 'Body Part';
  double width;

  @override
  void initState() {
    if (widget.data['diagnosis'] != null) {
      prakruti = widget.data['diagnosis']['prakruti'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> diagnosis = {};
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Diagnosis")),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: Form(
              key: _formkey,
              child: Wrap(runSpacing: 10.0, children: [
                TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                      labelText: "Urine",
                      labelStyle:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["Urine"] = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Stool",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["Stool"] = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Hunger",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["Hunger"] = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Thirst",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["thirst"] = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "tongue",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["tongue"] = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "teeth",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["teeth"] = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Mences",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      diagnosis["mences"] = value;
                    });
                  },
                ),
                Center(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                Center(
                  child: Text("Prakruti",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800])),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ListTile(
                      horizontalTitleGap: 0.0,
                      title: const Text('Vata'),
                      leading: Radio(
                        value: "Vata",
                        groupValue: prakruti,
                        onChanged: (value) {
                          setState(() {
                            prakruti = value;
                          });
                        },
                      ),
                    )),
                    Expanded(
                      child: ListTile(
                        horizontalTitleGap: 0.0,
                        title: const Text('Pitta'),
                        leading: Radio(
                          value: "Pitta",
                          groupValue: prakruti,
                          onChanged: (value) {
                            setState(() {
                              prakruti = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListTile(
                      horizontalTitleGap: 0.0,
                      title: const Text(
                        'Cough',
                      ),
                      leading: Radio(
                        value: "Cough",
                        groupValue: prakruti,
                        onChanged: (value) {
                          setState(() {
                            prakruti = value;
                          });
                        },
                      ),
                    )),
                  ],
                ),
                Row(children: [
                  Expanded(
                      child: DropdownButton<String>(
                    value: fingers,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onTap: () {
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    style: const TextStyle(color: Colors.green),
                    underline: Container(height: 2),
                    onChanged: (newValue) {
                      setState(() {
                        fingers = newValue;
                      });
                    },
                    items: <String>[
                      "Fingers",
                      'Agni',
                      'Vaayu',
                      'Aakash',
                      'Prithvi',
                      "Jal"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
                  Expanded(
                      child: DropdownButton<String>(
                    value: prana,
                    onTap: () {
                      FocusManager.instance.primaryFocus.unfocus();
                    },
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.green),
                    underline: Container(height: 2),
                    onChanged: (newValue) {
                      setState(() {
                        prana = newValue;
                      });
                    },
                    items: <String>[
                      "Body Part",
                      "Prana",
                      'Udaan',
                      'Samaan',
                      'Apaan',
                      'Vyaan',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ))
                ]),
                Center(
                    child: Padding(
                  child: ElevatedButton(
                      onPressed: () {
                        _formkey.currentState.save();
                        diagnosis['prakruti'] = prakruti;
                        diagnosis['fingers'] = fingers;
                        diagnosis['bodypart'] = prana;
                        widget.data['diagnosis'] = diagnosis;
                      },
                      //   if ( != "") {
                      //     widget.data['daily'] = ;
                      //   }
                      // },
                      child: Text("Save")),
                  padding: EdgeInsets.all(10),
                ))
              ]),
            ),
          ),
        ));
  }
}
