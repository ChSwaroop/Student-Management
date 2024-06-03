// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:student_mng/DBoperationsRepo/crudoperations.dart';
import 'package:student_mng/util/reusables.dart';
import 'package:student_mng/util/textformfields.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var _date = "Select DOB";
  DateTime _dateTime = DateTime.now();
  bool isDateSelected = false;
  bool isGenderSelected = false;
  bool validation = false;
  var dropDownValue = 'Select';
  final _key = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController name = TextEditingController();

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

    bool check() {
      if (dropDownValue != "Select") {
        isGenderSelected = true;
      } else {
        isGenderSelected = false;
      }

      if (_date != "Select DOB") {
        isDateSelected = true;
      } else {
        isDateSelected = false;
      }

      setState(() {
        validation = true;
      });
      debugPrint(
          "-----Gen--$isGenderSelected-----Date---$isDateSelected-----------");
      return isGenderSelected && isDateSelected;
    }

    var items = ['Select', 'Male', 'Female'];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container(

                //   height: MediaQuery.of(context).size.height/2.2,
                //   child: Lottie.asset('assets/lotties/student.json'),
                Reusable.container(
                    Colors.grey.shade300,
                    18,
                    MediaQuery.of(context).size.height / 2.2,
                    double.infinity,
                    Lottie.asset('assets/lotties/student.json')),
                    SizedBox(height: 20,),
                TextFormFields.formField("Enter Student Name", (value) {
                  if (value.length == 0) {
                    return "Enter Name";
                  }
                }, name, "Student Name"),
                const SizedBox(
                  height: 20,
                ),
                // ignore: sized_box_for_whitespace
                Container(
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
                (validation)
                    ? ((isDateSelected)
                        ? const SizedBox(height: 10)
                        : Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                child: Reusable.text('Select Date'),
                              ),
                            ],
                          ))
                    : const SizedBox(height: 10),
                const SizedBox(
                  height: 10,
                ),

                Container(
                  // padding: EdgeInsets.all(),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      // color: mainColor,
                      border: Border.all(color: Colors.black45)),
                  child: DropdownButton(
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      value: dropDownValue,
                      items: items.map((e) {
                        return DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.green.shade800),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        dropDownValue = value!;
                        setState(() {});
                      }),
                ),

                // if(validation)
                //   if(isGenderSelected)
                //     SizedBox(height: 10,)
                //   else
                //      Reusable.text('gender')
                // else
                //   SizedBox(height: 10),
                (validation)
                    ? ((isGenderSelected)
                        ? const SizedBox(height: 10)
                        : Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 10),
                                child: Reusable.text('Select Gender'),
                              ),
                            ],
                          ))
                    : const SizedBox(height: 10),
                // (!validation || isGenderSelected) ? SizedBox(height: 10,) : Reusable.text('gender'),
                const SizedBox(
                  height: 10,
                ),

                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 7,
                        ),
                        onPressed: () async {
                          isLoading = true;
                          setState(() {});

                          bool isCheck = check();
                          if (_key.currentState!.validate() && isCheck) {
                            debugPrint("All values are entered man");
                            await CRUDOperartions().addUser(name.text.trim(),
                                _dateTime, dropDownValue, context);
                            dropDownValue = 'Select';
                            _date = 'Select DOB';
                            name.clear();
                          }
                          setState(() {
                            isLoading = false;
                          });
                          debugPrint("OK");
                          //
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 17),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
