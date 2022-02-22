import 'package:flutter/material.dart';

class SnackBarScope {
  static show(String text) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Скрыть',
        onPressed: () {},
      ),
    );
  }
}
