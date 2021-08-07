import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String current = auth.currentUser.phoneNumber;

class ClientAppoint extends StatefulWidget {
  @override
  ClientAppointState createState() => new ClientAppointState();
}

class ClientAppointState extends State<ClientAppoint> {
  @override
  void initState() {
    _loadItems();
    super.initState();
  }

  Map<String, dynamic> data;
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  final Tween<Offset> offset = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  List<dynamic> _items = [];
  int counter = 0;
  List<dynamic> test = [];
  List<dynamic> prev = [];
  bool visibility = false;

  Future<void> _loadItems() async {
    String phone = auth.currentUser.phoneNumber;
    FirebaseFirestore.instance
        .collection('Appointments')
        .doc(phone)
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              documentSnapshot.data().forEach((key, value) {
                if (value != null) {
                  if (!value['date'].toDate().isBefore(DateTime.now())) {
                    test.add(value);
                  } else {
                    prev.add(value);
                  }
                }
              }),
              test.sort((a, b) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              prev.sort((b, a) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              print(test),
              setState(() {}),
              addDelay(test),
            });
  }

  addDelay(text) async {
    for (var item in text) {
      // 1) Wait for one second
      //await Future.delayed(Duration(milliseconds: 100));
      // 2) Adding data to actual variable that holds the item.
      _items.add(item);
      // 3) Telling animated list to start animation
      try {
        _listkey.currentState.insertItem(_items.length - 1);
      } on NoSuchMethodError catch (e) {
        print(e);
      }
    }
    setState(() {
      visibility = true;
    });
  }

  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff6fef6),
      body: Container(
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipPath(
                clipper: HeaderClip(),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green[300],
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 5),
                              spreadRadius: 5)
                        ]),
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
                            padding: const EdgeInsets.fromLTRB(43, 0, 0, 45),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xfff6fef6)),
                                ),
                                Text(
                                  "Appointments",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xfff6fef6)),
                                ),
                              ],
                            ),
                          ),
                        ])),
              ),
              // Divider(
              //   indent: 20,
              //   endIndent: MediaQuery.of(context).size.width * 0.2,
              // ),
              AnimatedOpacity(
                  opacity: visibility ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      ' Upcoming appointments : ',
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[700]),
                    ),
                  )),
              // if (test.isEmpty)
              //   AnimatedOpacity(
              //     opacity: visibility ? 1.0 : 0.0,
              //     duration: Duration(milliseconds: 500),
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(40, 4, 10, 3),
              //       child: Container(
              //         child: Text(
              //           "No upcoming appointments.",
              //           style: TextStyle(
              //             color: Colors.grey,
              //             fontSize: 15,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ),
              //   )
              // else
              AnimatedList(
                  shrinkWrap: true,
                  key: _listkey,
                  initialItemCount: _items.length,
                  itemBuilder: (context, index, animate) {
                    return SlideTransition(
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23)),
                                child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23))),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              color: Colors.green[300],
                                              width: 10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(children: [
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 23,
                                              ),
                                            ]),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    DateFormat.yMMMd().format(
                                                        _items[index]['date']
                                                            .toDate()),
                                                    style: TextStyle(
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.green[900]),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    _items[index]['time'],
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blueGrey[700]),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  Text(
                                                    _items[index]
                                                        ['therapy name'],
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blueGrey[700]),
                                                  ),
                                                ]),
                                          ),
                                        ]),
                                      ]),
                                    ),
                                  ),
                                ),
                              ))),
                      position: animate.drive(offset),
                    );
                  }),
              SizedBox(
                height: 19,
              ),
              AnimatedOpacity(
                  opacity: visibility ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      accentColor: Colors.grey,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        ' Previous appointments ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueGrey[500]),
                      ),
                      children: [
                        for (var value in prev)
                          if (value['date'].toDate().isBefore(DateTime.now()))
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                child: Column(children: [
                                  Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(23)),
                                    child: ClipPath(
                                      clipper: ShapeBorderClipper(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(23))),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.grey[400],
                                                  width: 10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(children: [
                                            Row(children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 23,
                                                  ),
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 13),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        DateFormat.yMMMd()
                                                            .format(
                                                                value['date']
                                                                    .toDate()),
                                                        style: TextStyle(
                                                            fontSize: 21,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .green[900]),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        value['time'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .blueGrey[700]),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Text(
                                                        value['therapy name'],
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors
                                                                .blueGrey[700]),
                                                      ),
                                                    ]),
                                              ),
                                            ]),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                      ],
                    ),
                  )),
            ])
          ],
        ),
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
}

class HeaderClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 50);
    var controllPoint = Offset(50, size.height);
    var endPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
