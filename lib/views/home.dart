// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_mng/views/bottombarScreens/form.dart';
import 'package:student_mng/views/bottombarScreens/students.dart';
import 'package:student_mng/views/signup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = [AddUser(), Students()];
  int ind = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: screens[ind],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: ind,
          selectedItemColor: Colors.green.shade800,
          unselectedItemColor: Colors.grey,
          onTap: (value) {
            ind = value;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "List")
          ]),
    );
  }
}
