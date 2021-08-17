import 'package:flutter/material.dart';

class GlobalWidgets {
  static void showSnackBar(
    BuildContext context,
    String text,
    Color backgroundColor,
    int durationInMillisecond,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: backgroundColor,
        duration: Duration(
          milliseconds: durationInMillisecond,
        ),
      ),
    );
  }
}
