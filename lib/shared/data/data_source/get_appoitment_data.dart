import 'package:cloud_firestore/cloud_firestore.dart';

class Appoitment {
  getAppoitment(String staffId) async {
    try {
      final firebase = FirebaseFirestore.instance.collection('appointments');
      var selectedAppoitmentData =
          firebase.doc(staffId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          dynamic id = documentSnapshot.id;
          dynamic serData = documentSnapshot.data();
          return {'id': id, ...serData};
        } else {
          print('Appoitment does not exist on the database');
        }
      });
      return selectedAppoitmentData;
    } catch (e) {
      print(e);
    }
  }
}
