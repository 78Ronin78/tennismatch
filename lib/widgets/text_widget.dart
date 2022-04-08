import 'package:flutter/material.dart';

// ignore: camel_case_types
class Text_Widget extends StatelessWidget {
  final String text;
  final String signText;

  const Text_Widget({this.text, this.signText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          ' ' + signText,
          style: TextStyle(
            color: Color(0xFFADFF2F),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
