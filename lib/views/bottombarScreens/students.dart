// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_mng/DBoperationsRepo/crudoperations.dart';
import 'package:student_mng/util/constants.dart';
import 'package:student_mng/util/reusables.dart';
import 'package:student_mng/util/textformfields.dart';
import 'package:student_mng/views/shimmer.dart';

class Students extends StatefulWidget {
  const Students({super.key});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  String searchString = "";
  var _date = "Select DOB";
  DateTime _dateTime = DateTime.now();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  bool isLoading = false;

  void snackbar(BuildContext context, String msg, final data) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            CRUDOperartions().addUser(
                data['Name'], data['DOB'].toDate(), data['Gender'], context);
          }),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    void _showDateTimePicker() {
      // debugPrint(name.text);

      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
      ).then((value) {
        _date = value.toString().substring(0, value.toString().length - 13);
        _dateTime = value!;
        setState(() {});
      });
    }

    Future<dynamic> alert(var data) {
      _name.text = data['Name'];
      _gender.text = data['Gender'];
      // _date = data['DOB'].toString().substring(0 , data['DOB'].toString().length-13);
      Timestamp ts = data['DOB'];
      DateTime dt = ts.toDate();
      _date = DateFormat('yyyy-mm-dd').format(dt);

      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(10),
              content: Container(
                padding: const EdgeInsets.all(20),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      TextFormFields.formField('Enter Name', (value) {
                        if (value == "") return 'Enter Name';
                      }, _name, 'Name'),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            onPressed: _showDateTimePicker,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_date),
                                const Icon(Icons.calendar_month)
                              ],
                            )),
                      ),
                      const SizedBox(height: 20),
                      TextFormFields.formField('Enter Gender', (val) {
                        if (val == "") return "Enter Gender";
                      }, _gender, 'Gender'),
                      const SizedBox(
                        height: 20,
                      ),
                      (isLoading)
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                await CRUDOperartions().updateUser(
                                    _name.text.trim(),
                                    _dateTime,
                                    _gender.text.trim(),
                                    context);

                                Navigator.pop(context);
                              },
                              child: const Text('Update')),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Reusable.container(
              cardColor,
              18,
              40,
              double.infinity,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Student"),
                        onChanged: (val) {
                          searchString = val;
                          setState(() {});
                        },
                      ),
                    ),
                    const Icon(Icons.equalizer)
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('students').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: ShimmerEffect());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No students found"));
                } else {
                  final data = (searchString != "")
                      ? snapshot.data!.docs.where((doc) {
                          return doc['Name'].toString().toLowerCase().contains(searchString.toLowerCase());
                        }).toList()
                      : snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, ind) {
                      Timestamp ts = data[ind]['DOB'];
                      DateTime dt = ts.toDate();
                      String format = DateFormat('yyyy-mm-dd').format(dt);

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        elevation: 10,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Reusable.container(
                                cardColor,
                                360,
                                100,
                                100,
                                const Icon(Icons.account_box, size: 50),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data[ind]['Name'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(format),
                                    const SizedBox(height: 8),
                                    Text(data[ind]['Gender']),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle view button press
                                      alert(data[ind]);
                                    },
                                    child: const Text("Update"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Handle view button press
                                      // alert(data[ind]);
                                      bool res = await CRUDOperartions()
                                          .deleteUser(
                                              data[ind]['Name'], context);
                                      if (res) {
                                        snackbar(
                                            context,
                                            'Student deleted successfully',
                                            data[ind]);
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
