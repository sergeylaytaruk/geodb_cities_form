import 'package:flutter/material.dart';
OutlineInputBorder inputDecoration() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(
      color:Colors.indigoAccent,
      width: 1.5,
    ),
  );
}
OutlineInputBorder selectDecoration() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(0)),
    borderSide: BorderSide(
      color:Colors.indigoAccent,
      width: 1.5,
    ),
  );
}