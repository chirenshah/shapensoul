import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../profile/profile.dart';

class AddRecipe extends StatefulWidget {
  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  List<String> names = [];
  @override
  Widget build(BuildContext context) {
    CollectionReference appointment =
        FirebaseFirestore.instance.collection('Recipe');
    return FutureBuilder<QuerySnapshot>(
        future: appointment.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            snapshot.data.docs.forEach((element) {
              if (element.data() != null) {
                names.add(element.data()['Name']);
              }
            });
            return Scaffold(
                appBar: AppBar(
                    title: Text('Shape N Soul',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        )),
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                            Color(0xff84EBAB),
                            Colors.green[300]
                          ])),
                    ),
                    automaticallyImplyLeading: false,
                    // backgroundColor: Color(0xfff6fef6),
                    actions: <Widget>[
                      IconButton(
                        icon: new Icon(Icons.exit_to_app),
                        onPressed: () {
                          showAlertDialog(context, 'Are you sure?');
                        },
                        tooltip: "Logout",
                      ),
                    ]),
                body: ListView(
                  children: [
                    for (var name in names)
                      Padding(
                        child: Text(name),
                        padding: EdgeInsets.all(8.0),
                      )
                  ],
                ));
          }
          return Text('loading');
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
          Navigator.pushReplacementNamed(context, "/login");
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

  signOut() async {
    await auth.signOut();
  }
}
