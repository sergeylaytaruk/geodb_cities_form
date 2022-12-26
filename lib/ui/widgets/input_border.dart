import 'package:flutter/material.dart';
OutlineInputBorder myInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(
      color:Colors.indigoAccent,
      width: 1,
    ),
  );
}