import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function onPressed;

  const ButtonWidget({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: 230,
        height: 55,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          primary: Color(0xFFADFF2F),
        ),
        onPressed: this.onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
