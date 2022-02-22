import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static String millisecondsToFormatString(String lastModified) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(lastModified));
    return DateFormat('HH:mm').format(dateTime);
  }

  static final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide(
      color: Colors.transparent,
    ),
  );

  final FirebaseFirestore fbFirestore = FirebaseFirestore.instance;
}
