import 'package:flutter/material.dart';
import 'package:shop_app/utils/constants.dart';

class GlobalWidgets {
  static void showSnackBar({
    @required BuildContext context,
    @required String text,
    Color backgroundColor,
    int duration = 4000,
    String actionLabel,
    Function onPressedAction,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: backgroundColor,
        duration: Duration(
          milliseconds: duration,
        ),
        action: SnackBarAction(
          // textColor: colorAccent,
          label: actionLabel ?? '',
          onPressed: onPressedAction ?? () {},
        ),
      ),
    );
  }

  static Future<T> presentDialog<T>({
    @required BuildContext context,
    @required String text,
    String title,
    String actionTitle1,
    String actionTitle2,
    Function actionFunction1,
    Function actionFunction2,
    Color titleColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title ?? '',
          style: TextStyle(
            color: titleColor ?? Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: actionFunction1,
            child: Text(actionTitle1 ?? ''),
          ),
          TextButton(
            onPressed: actionFunction2,
            child: Text(actionTitle2 ?? ''),
          ),
        ],
      ),
    );
  }
}
