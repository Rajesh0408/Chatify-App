import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  const CustomInputField(
      {required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (newValue) => onSaved(newValue!),
      cursorColor: Colors.white,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      validator: (newValue) {
        return RegExp(regEx).hasMatch(newValue!) ? null : "Enter a valid input";
      },
      decoration: InputDecoration(
          fillColor: Color.fromRGBO(30, 29, 37, 1.0),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white54)),


    );
  }
}

class CustomTextField extends StatelessWidget {
  final Function(String) onEditingComplete;
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  IconData? icon;

  CustomTextField(
      {required this.onEditingComplete,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onEditingComplete: () => onEditingComplete(controller.value.text),
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
      ),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.white54),
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.white54,)
      ),
    );
  }
}
