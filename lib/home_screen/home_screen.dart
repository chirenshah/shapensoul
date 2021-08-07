import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersns/home_screen/appointment/client_appoint.dart';
import 'package:fluttersns/home_screen/appointment/admin_appoint.dart';
import 'package:fluttersns/home_screen/diet/client_diet.dart';
import 'package:fluttersns/home_screen/diet/admin_diet.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttersns/home_screen/profile/profile_details.dart';
import '../notification.dart';
import 'package:fluttersns/home_screen/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  String phone = '';
  final List<Widget> _children = [
    (FirebaseAuth.instance.currentUser.phoneNumber == '+919987929313' ||
            FirebaseAuth.instance.currentUser.phoneNumber == '+918356879868')
        ? AdminAppoint()
        : ClientAppoint(),
    (FirebaseAuth.instance.currentUser.phoneNumber == '+919987929313' ||
            FirebaseAuth.instance.currentUser.phoneNumber == '+918356879868')
        ? AdminDiet()
        : Diet(),
    (FirebaseAuth.instance.currentUser.phoneNumber == '+919987929313' ||
            FirebaseAuth.instance.currentUser.phoneNumber == '+918356879868')
        ? Profile()
        : ProfileDetails(name: FirebaseAuth.instance.currentUser.phoneNumber)
  ];

  @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    initialise();
    super.initState();
  }

  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xfff6fef6),
        height: 50,
        color: Colors.green[300],
        buttonBackgroundColor: Color(0xfff6fef6),
        animationCurve: Curves.decelerate,
        items: <Widget>[
          Icon(Icons.calendar_today),
          Icon(Icons.description),
          if (FirebaseAuth.instance.currentUser.phoneNumber ==
                  '+919987929313' ||
              FirebaseAuth.instance.currentUser.phoneNumber == '+918356879868')
            Icon(Icons.person_outline),
        ],
        onTap: onTabTapped,
      ),
    );
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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void initialise() {
    phone = auth.currentUser.phoneNumber;
    print(FirebaseAuth.instance.currentUser.phoneNumber);
    FirebaseFirestore.instance
        .collection('Appointments')
        .doc(phone)
        .snapshots()
        .listen((DocumentSnapshot querySnapshot) async {
      await notificationPlugin.cancelAllNotification();
      print(querySnapshot.data());
      try {
        querySnapshot.data().forEach((key, value) {
          if (!value['date'].toDate().isBefore(DateTime.now())) {
            var date = value['date'].toDate().toString().split('.')[0];
            notificationPlugin.scheduleNotification(
                date, value['therapy name']);
          }
        });
      } on NoSuchMethodError {
        print("Error");
      }
    }).onError((e) {
      print(e);
    });
  }
}
