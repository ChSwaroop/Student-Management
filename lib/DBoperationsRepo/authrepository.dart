import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final auth = FirebaseAuth.instance;
  late Timer _timer;

  void snackbar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> sendEmail(String email, String pass, Function onEmailVerified,
      BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      User user = userCredential.user!;

      if (!user.emailVerified) {
        await auth.currentUser!.sendEmailVerification();
        debugPrint("Email sent");
        autoRedirect(onEmailVerified, context);
      }
    } on FirebaseAuthException catch (fe) {
      if (fe.code == 'email-already-in-use') {
        snackbar(context, 'Email already exists');
      } else if (fe.code == 'weak-password') {
        snackbar(context, 'Weak Password');
      } else {
        snackbar(context, fe.code);
      }
      debugPrint(fe.toString());
    }
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = userCredential.user!;
      debugPrint("-------------------${userCredential.toString()}---------");
      debugPrint("================${user.toString()}===========");

      if (user.emailVerified)
        return true;
      else {
        auth.currentUser!.delete();
        return false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("-=-=-=-=-=-=-${e.toString()}-=-=-=-=-=-=");
      snackbar(context, e.code);
      return false;
    }
  }

  bool autoRedirect(Function onEmailVerified, BuildContext context) {
    bool res = false;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      auth.currentUser!.reload();
      if (auth.currentUser!.emailVerified) {
        _timer.cancel();
        res = true;
        debugPrint("//////Inside///////${res.toString()}///////");
        onEmailVerified();
      }
    });
    debugPrint("/////////////${res.toString()}///////");
    return res;
  }
}
