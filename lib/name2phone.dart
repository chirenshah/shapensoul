import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> name2phone(name) async {
  var phone = '';
  await FirebaseFirestore.instance
      .collection('Names')
      .doc(name)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    phone = documentSnapshot['phone'];
  }).catchError((error) {
    print(error.message);
  });
  return phone;
}
