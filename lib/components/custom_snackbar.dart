import 'package:flutter/material.dart';
import '../constaints.dart';

class CustomSnackbar {
  static snackbar(context, message, type) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: (type == 'warning')
              ? warningColor
              : normalColor,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                color: (type == 'warning') ? Colors.white : Colors.black
            ),
          ),
          duration: Duration(milliseconds: 2000),
          padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
        )
    );
  }
}