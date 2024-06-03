import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CRUDOperartions {
  final db = FirebaseFirestore.instance.collection('students');

  void snackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> addUser(String name, DateTime dateTime, String gender,
      BuildContext context) async {
    try {
      await db.doc(name).set({'Name': name, 'DOB': dateTime, 'Gender': gender});

      debugPrint("Sucessfully Inserted");
      snackbar(context, 'Student added Successfully');
    } catch (e) {
      debugPrint("----Error$e-----");
    }
  }

  Future<void> updateUser(
      String name, DateTime dt, String gender, BuildContext context) async {
    try {
      await db.doc(name).update(
        {
          'Name': name,
          'DOB': dt,
          'Gender': gender,
        },
      );
      snackbar(context, 'Student Updated Successfully');
    } on FirebaseException catch (e) {
      debugPrint(e.code);
      snackbar(context, e.code);
    }
  }

  Future<bool> deleteUser(String name, BuildContext context) async {
    try {
      await db.doc(name).delete();
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.code);
      snackbar(context, e.code);
      return false;
    }
  }
}
