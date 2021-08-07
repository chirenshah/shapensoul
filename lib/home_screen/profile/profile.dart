import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttersns/name2phone.dart';
import 'package:fluttersns/home_screen/appointment/client_appoint.dart';
import 'profile_details.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class Profile extends StatefulWidget {
  @override
  _Profile createState() => new _Profile();
}

class _Profile extends State<Profile> {
  @override
  void initState() {
    getProfile();
    super.initState();
  }

  signOut() async {
    await auth.signOut();
  }

  List<String> suggestions = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  SimpleAutoCompleteTextField textField;
  String submit = '';
  _Profile() {
    Row(
      children: [
        textField = SimpleAutoCompleteTextField(
          key: key,
          decoration: new InputDecoration(
            labelText: "Search Client",
            prefixIcon: Icon(Icons.search),
          ),
          controller: TextEditingController(text: ""),
          suggestions: suggestions,
          textChanged: (text) => currentText = text,
          clearOnSubmit: true,
          textSubmitted: (text) => setState(() {
            if (text != "") {
              if (text == "admin") {
                setState(() {
                  submit = '';
                });
              } else {
                setState(() {
                  submit = text;
                });
              }
            }
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6fef6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: HeaderClip(),
                child: Container(
                    decoration: BoxDecoration(color: Colors.green[300]),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 13, 20, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 15),
                                  child: Image.asset('assets/images/Frame.png',
                                      width: 50, height: 40),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: IconButton(
                                    icon: new Icon(
                                      Icons.exit_to_app,
                                      color: Color(0xfff6fef6),
                                      size: 26,
                                    ),
                                    onPressed: () {
                                      showAlertDialog(context, 'Are you sure?');
                                    },
                                    tooltip: "Logout",
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 0, 45),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                "Client Profile ",
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xfff6fef6)),
                              ),
                            ),
                          ),
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.all(13),
                child: ListTile(title: textField),
              ),
              ProfileStateless(
                name: submit,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.person_add),
        onPressed: () {
          Navigator.pushNamed(context, '/add_profile');
        },
        backgroundColor: Colors.green[300],
      ),
    );
  }

  Future<void> getProfile() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                suggestions.add(doc.data()["name"]);
              }),
            });
  }

  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(fontSize: 20),
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
          signOut();
          Navigator.pushNamedAndRemoveUntil(
              context, "/login", ModalRoute.withName('/login'));
        });

    AlertDialog alert = AlertDialog(
        title: const Text(
          "LOGOUT",
          style: TextStyle(fontSize: 21),
        ),
        content: Text(
          '\n$message',
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
}

class ProfileStateless extends StatelessWidget {
  final String name;

  ProfileStateless({
    Key key,
    @required this.name,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Users');
    Widget list = Container(
      child: CircularProgressIndicator(
        backgroundColor: Colors.green[300],
      ),
    );
    if (name == '') {
      list = FutureBuilder<QuerySnapshot>(
          future: appointment.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    for (var name in snapshot.data.docs)
                      Card(
                        color: const Color(0xfff7fdf7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              child: Text(name['name'][0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              backgroundColor: Colors.green[200],
                            ),
                            trailing: Icon(Icons.navigate_next),
                            title: Text(
                              name['name'],
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              var phone;
                              name2phone(name['name']).then((value) => {
                                    phone = value,
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileDetails(name: phone),
                                        ))
                                  });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return CircularProgressIndicator(
              backgroundColor: Color(0xfff6fef6),
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.green[300]),
            );
          });
    } else {
      list = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xfff7fdf7),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    child: Text(name[0],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                    backgroundColor: Colors.green[200],
                    // backgroundImage: CachedNetworkImageProvider(core.url + "profiles/" + friendlist[index]["avatar_id"]),
                  ),
                  trailing: Icon(Icons.navigate_next),
                  title: Text(
                    name,
                    style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 21,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    var phone;
                    name2phone(name).then((value) => {
                          phone = value,
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileDetails(name: phone),
                              ))
                        });
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return list;
  }
}
