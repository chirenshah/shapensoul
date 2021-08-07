import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttersns/name2phone.dart';
import 'package:intl/intl.dart';

class PrevAppoint extends StatefulWidget {
  final String name;
  PrevAppoint({Key key, @required this.name}) : super(key: key);
  @override
  PrevAppointState createState() => new PrevAppointState();
}

class PrevAppointState extends State<PrevAppoint> {
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();
  List<dynamic> appoint = [];
  List<dynamic> unSortedAppoint = [];
  var phone;
  final Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  @override
  void initState() {
    name2phone(widget.name).then((value) => {
          setState(() {
            phone = value;
          }),
          userAppoint(phone)
        });

    super.initState();
  }

  userAppoint(phone) {
    FirebaseFirestore.instance
        .collection('Appointments')
        .doc(phone)
        .get()
        .then((DocumentSnapshot documentSnapshot) => {
              //test.removeRange(0, test.length - 1),
              documentSnapshot.data().forEach((key, value) {
                if (value['date'].toDate().isBefore(DateTime.now()))
                  unSortedAppoint.add(value);
              }),
              unSortedAppoint.sort((a, b) {
                return a['date'].toDate().compareTo(b['date'].toDate());
              }),
              addDelay(unSortedAppoint)
            });
  }

  addDelay(text) async {
    for (var item in text) {
      // 1) Wait for one second
      await Future.delayed(Duration(milliseconds: 100));
      // 2) Adding data to actual variable that holds the item.
      item['date'] = DateFormat.yMMMd().format(item['date'].toDate());
      appoint.add(item);
      // 3) Telling animated list to start animation
      try {
        _listkey.currentState.insertItem(appoint.length - 1);
      } on NoSuchMethodError catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: [
              AnimatedList(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  key: _listkey,
                  initialItemCount: appoint.length,
                  itemBuilder: (context, index, animate) {
                    return SlideTransition(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green[100].withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 9,
                                // offset:
                                //     Offset(0, 4), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23)),
                              child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 23,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 1, 1, 5),
                                                  child: Text(
                                                    appoint[index]
                                                        ['client name'],
                                                    style: TextStyle(
                                                      color: Colors.green[900],
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15, 1, 1, 5),
                                                  child: Text(
                                                    appoint[index]
                                                        ['therapy name'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          1, 1, 25, 5),
                                                  child: Text(
                                                    appoint[index]['date'],
                                                    style: TextStyle(
                                                      color: Colors.green[900],
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          1, 1, 25, 5),
                                                  child: Text(
                                                    appoint[index]['time'],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ]))),
                        ),
                      ),

                      // Text(appoint[index]['therapy name']),
                      position: animate.drive(offset),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
