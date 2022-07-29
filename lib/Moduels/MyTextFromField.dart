import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myTextFromField({
  required String labelText,
  required TextEditingController controller,
  required FormFieldValidator<String> validate,
  required IconData icon,
  FormFieldSetter<String>? onSubmitted,
  TextInputType keyboardType=TextInputType.text,
  GestureTapCallback ?ontap,
}) {
  return Container(
    margin:  const EdgeInsetsDirectional.only(top: 20,start: 10,end: 10),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validate,
      onTap: ontap,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),

    ),
  );
}