import 'package:flutter/material.dart';
import 'package:student_mng/util/constants.dart';

class TextFormFields {
  static TextFormField formField(String hintText, callback,
      TextEditingController controller, String label) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),

        label: Text(label),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: mainColor)),
        // hintText: hintText
      ),
      validator: callback,
      controller: controller,
      obscureText: (label == "Password"),
    );
  }
}
