import 'package:flutter/material.dart';

Widget getMyField(
    {required String hintText,
    TextInputType textInputType = TextInputType.name,
    required TextEditingController controller,
    FocusNode? focusNode}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: TextField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
          hintText: 'Enter $hintText',
          labelText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    ),
  );
}
