import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Function onPressed;

  const CustomButton({super.key, required this.text, required this.height, required this.width, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height * 0.25),
          color: Color.fromRGBO(0, 82, 218, 1.0)
        ),
        child: TextButton(
          onPressed: () => onPressed(),
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 22, height: 1.6),),
        ),
    );
  }
}
