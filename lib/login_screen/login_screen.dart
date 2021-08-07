import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttersns/login_screen/widget/country_picker.dart';
import 'package:fluttersns/login_screen/widget/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _contactEditingController = TextEditingController();
  List<String> numbers = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((value) => value.docs.forEach((value) {
              numbers.add(value['personal']['phone']);
            }));
    super.initState();
  }

  //Login click with contact number validation
  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, "Contact number can't be empty.");
    } else {
      String pnumber =
          "+91 " + _contactEditingController.text.toString().trim();
      if (numbers.contains('+91' + _contactEditingController.text)) {
        final responseMessage = await Navigator.pushNamed(context, '/otp',
            // arguments:'$_dialCode${_contactEditingController.text.toString().trim()}');
            arguments: pnumber);
        if (responseMessage != null) {
          showErrorDialog(context, responseMessage as String);
        }
      } else {
        showErrorDialog(
            context, 'Please visit our Clinic to activate your app');
      }
    }
  }

  //callback function of country picker
  // void _callBackFunction(String name, String dialCode, String flag) {
  //   _dialCode = dialCode;
  // }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
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

  //build method for UI Representation
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffe5fbe5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Image.asset(
                  'assets/images/nat.png',
                  width: screenWidth * 0.4,
                  fit: BoxFit.contain,
                ),
                // Image.asset(
                //   'assets/images/logo.png',
                //   width: screenWidth * 0.7,
                //   fit: BoxFit.contain,
                // ),
                // SizedBox(
                //   height: screenHeight * 0.05,
                // ),
                // Image.asset(
                //   'assets/images/registration.png',
                //   height: screenHeight * 0.3,
                //   fit: BoxFit.contain,
                // ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                const Text('Dr. Trupti Shah',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff4e342e),
                    )),
                SizedBox(
                  height: screenHeight * 0.18,
                ),
                const Text(
                  'Enter your mobile number to receive a verification code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: const Color(0xfff6fef6),
                      // ignore: prefer_const_literals_to_create_immutables
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green[300],
                          ),
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Contact Number',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 13.5),
                                ),
                                controller: _contactEditingController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      CustomButton(clickOnLogin),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
