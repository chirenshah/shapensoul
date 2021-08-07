import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  final Map<String, dynamic> data;
  Personal({Key key, @required this.data}) : super(key: key);
  @override
  _PersonalState createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final _formkey = GlobalKey<FormState>();
  String name = "";
  String phone = "";
  String age;
  String weight;
  String dropdownValue = "Gender";
  String bp;
  String history;
  String medication;
  String symptoms = "";

  double _height;
  double _width;

  @override
  void initState() {
    print(widget.data);
    if (widget.data['personal'] != null) {
      name = widget.data['name'];
      phone = widget.data['personal']['phone'];
      age = widget.data['personal']['age'];
      weight = widget.data['personal']['weight'];
      dropdownValue = widget.data['personal']['Gender'];
      bp = widget.data['personal']['Bloodpressure'];
      history = widget.data['personal']['history'];
      medication = widget.data['personal']['medication'];
      symptoms = widget.data['personal']['Symptoms'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Personal")),
        body: SingleChildScrollView(
            child: Container(
          width: _width,
          margin:
              const EdgeInsets.only(top: 20, left: 30, right: 40, bottom: 20),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter a Name";
                    }
                    return null;
                  },
                  initialValue: name,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Name",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return "Please Enter a valid Phone Number";
                    }
                    return null;
                  },
                  initialValue: phone,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Phone Number",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child: TextFormField(
                    initialValue: age,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Age",
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300)),
                    onSaved: (value) {
                      setState(() {
                        age = value;
                      });
                    },
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: TextFormField(
                    initialValue: weight,
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Weight",
                        labelStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300)),
                    onSaved: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  ))
                ]),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.lightBlue),
                      underline: Container(height: 2),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>["Gender", 'Male', 'Female', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextFormField(
                      initialValue: bp,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "B.P",
                          labelStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300)),
                      onSaved: (value) {
                        setState(() {
                          bp = value;
                        });
                      },
                    )),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: history,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 35, 0, 35),
                      border: UnderlineInputBorder(),
                      labelText: "History",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      history = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: medication,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 35, 0, 35),
                      border: UnderlineInputBorder(),
                      labelText: "Medication",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      medication = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: symptoms,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 35, 0, 35),
                      border: UnderlineInputBorder(),
                      labelText: "Symptoms",
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                  onSaved: (value) {
                    setState(() {
                      symptoms = value;
                    });
                    append();
                  },
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState.validate()) {
                            _formkey.currentState.save();
                          }
                        },
                        child: Text("Save")))
              ],
            ),
          ),
        )));
  }

  void append() {
    Map<String, String> personal;
    personal = {
      "phone": phone,
      "age": age,
      "Bloodpressure": bp,
      "weight": weight,
      "Gender": dropdownValue,
      "history": history,
      "medication": medication,
      "Symptoms": symptoms
    };
    widget.data['name'] = name;
    widget.data["personal"] = personal;
  }
}
