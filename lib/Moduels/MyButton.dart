import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myMaterialButton({
  double width=double.infinity,
  Color background=Colors.blue,
  required VoidCallback ?functionPressed,
  required String text,
}){
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(40),
      ),
      child: MaterialButton(
        onPressed:functionPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}