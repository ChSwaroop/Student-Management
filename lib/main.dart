import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_mng/util/constants.dart';
import 'package:student_mng/views/home.dart';
import 'package:student_mng/views/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            debugPrint(snapshot.data.toString());

            if (snapshot.hasData) {
              if (snapshot.data!.emailVerified) {
                return const HomeScreen();
              } else {
                return const SignUp();
              }
            } else {
              return const SignUp();
            }
          }),
      // home: SignUp(),
    );
  }
}
