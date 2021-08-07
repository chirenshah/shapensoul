import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersns/home_screen/home_screen.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
//import '../home_screen/appointment/client_appoint.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  List<String> numbers = [];
  final _contactEditingController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  bool opacity = true;
  bool waitedFlag = true;
  String smsOTP;
  String phoneNo;
  String verificationId;
  int time = 30;
  Timer timer;
  String errorMessage = '';
  double leftpadding;
  double toppadding;
  var token;
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // final screenHeight = MediaQuery.of(context).size.height;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    setState(() {
      leftpadding = 0;
      toppadding = 0;
    });
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((value) => value.docs.forEach((value) {
              numbers.add(value['personal']['phone']);
            }));
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => setState(() {
              if (time > 0) {
                time = time - 1;
              }
            }));
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> generateOtp(String contact) async {
    final PhoneCodeSent smsOTPSent =
        (String verId, [int forceResendingToken]) async {
      verificationId = verId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: contact,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
            Navigator.of(context).pop();
            Navigator.of(context).push(_createRoute());
          },
          verificationFailed: (FirebaseAuthException exception) {
            // Navigator.pop(context, exception.message);
          });
      setState(() {
        time = 30;
      });
    } catch (e) {
      handleError(e);
      // Navigator.pop(context, (e as PlatformException).message);
    }
  }

  Future<void> verifyOtp() async {
    if (smsOTP == null || smsOTP == '') {
      showAlertDialog(context, 'please enter 6 digit otp');
      return;
    }
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential user = await _auth.signInWithCredential(credential);
      final User currentUser = _auth.currentUser;
      assert(user.user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).push(_createRoute());
    } catch (e) {
      handleError(e);
    }
  }

  void handleError(error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message);
        break;
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
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

  Future<void> clickOnLogin(double screenHeight, double screenWidth) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, "Contact number can't be empty.");
    } else {
      String pnumber =
          "+91 " + _contactEditingController.text.toString().trim();
      if (numbers.contains('+91' + _contactEditingController.text)) {
        setState(() {
          phoneNo = pnumber;
        });
        generateOtp(pnumber);
        _controller.forward();
        setState(() {
          leftpadding = screenWidth * 0.05;
          toppadding = screenHeight * 0.1;
          opacity = false;
        });
        delay(false);
      } else {
        showErrorDialog(
            context, 'Please visit our Clinic to activate your app');
      }
    }
  }

  Future<void> delay(flag) async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      waitedFlag = flag;
    });
  }

  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Yes'),
        )
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(),
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                    color: Colors.white,
                    child: Column(children: [
                      ClipPath(
                        clipper: HeaderClip(),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.green[300]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset('assets/images/Frame.png',
                                      height: 180, width: 180),
                                ),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  padding: EdgeInsets.fromLTRB(
                                      leftpadding, toppadding, 0, 0),
                                  child: Text(
                                    "SHAPE N SOUL",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]),
                          width: screenWidth,
                          height: 400,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Stack(children: [
                        AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: opacity ? 0.0 : 1.0,
                            child: Column(
                              children: [
                                Text(
                                  'Enter A 6 digit number that was sent to ${_contactEditingController.text}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _controller.reverse();
                                    setState(() {
                                      opacity = true;
                                      leftpadding = 0;
                                      toppadding = 0;
                                    });
                                    delay(true);
                                  },
                                  child: Text('Change Number',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      boxShadow: [
                                        const BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              screenWidth * 0.03,
                                              screenHeight * 0.025,
                                              0,
                                              0),
                                          child: PinEntryTextField(
                                            fields: 6,
                                            onSubmit: (text) {
                                              smsOTP = text as String;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.04,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            verifyOtp();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(36),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Verify',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        if (time == 0)
                                          GestureDetector(
                                            onTap: () {
                                              generateOtp(phoneNo);
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(8),
                                              height: 45,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(36),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Resend OTP',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        else
                                          Container(
                                            margin: const EdgeInsets.all(8),
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(36),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Resend OTP in ${time}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                      ]),
                                  width: screenWidth * 0.9,
                                  height: screenHeight * 0.31,
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  padding: EdgeInsets.all(15),
                                ),
                              ],
                            )),
                        if (waitedFlag)
                          AnimatedOpacity(
                            opacity: opacity ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Column(children: [
                              Container(
                                  child: Text(
                                    'Enter your mobile number to receive a verification code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  width: screenWidth * 0.8),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth > 600
                                          ? screenWidth * 0.2
                                          : 16),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      boxShadow: [
                                        const BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0.0, 1.0), //(x,y)
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Column(children: [
                                    Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      height: 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green[300],
                                        ),
                                        borderRadius: BorderRadius.circular(36),
                                      ),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Contact Number',
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 13.5),
                                        ),
                                        controller: _contactEditingController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        clickOnLogin(screenHeight, screenWidth);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        height: screenHeight * 0.05,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.green[500],
                                          borderRadius:
                                              BorderRadius.circular(36),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Send OTP',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  height: screenHeight * 0.2),
                            ]),
                          )
                      ])
                    ])))));
  }
}

class HeaderClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 100);
    var controllPoint = Offset(0, size.height);
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
