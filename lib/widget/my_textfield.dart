import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {super.key,
        required this.controller,
        required this.hintText,
        required this.labelText,
        required this.errorMessage,
      }
      );
  final String labelText;
  final TextEditingController controller;
  final String hintText;
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        controller: controller,
        validator : (value){
          if(value!.isEmpty){
            return "Please enter some text";
          }
          return null;
        }
    );
  }
}
