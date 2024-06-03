import 'package:flutter/material.dart';
import 'package:student_mng/util/constants.dart';

class Reusable {
  static Container container(
      Color color, double radius, double height, double width, Widget child) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
          border: Border.all(color: mainColor)),
      child: child,
    );
  }

  static Text text(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.red.shade900, fontSize: 11.5),
    );
  }
}
