import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Staff {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<dynamic> signInStaff(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final newuser = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return newuser.user!.uid;
    } catch (e) {
      print(e);
    }
  }

  getStaffDetail() async {
    String staffId;
    dynamic staffData;

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('staff').get();
      staffData = querySnapshot.docs.map((doc) {
        staffId = doc.id;
        staffData = doc.data();
        return {'id': staffId, ...staffData};
      }).toList();
      return staffData;
    } catch (e) {
      print(e);
    }
  }

  getSelectStaffDetail(String staffId) async {
    try {
      final firebase = FirebaseFirestore.instance.collection('staff');
      var selectedStaffData =
          firebase.doc(staffId).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          var id = documentSnapshot.id.toString();
          dynamic serData = documentSnapshot.data();
          return {'id': id, ...serData};
        } else {
          print('User does not exist on the database');
        }
      });
      return selectedStaffData;
    } catch (e) {
      print(e);
    }
  }

  String getCurrentStaff() {
    final staffEmail = firebaseAuth.currentUser!.email;
    return staffEmail!;
  }
}
