import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';

void showException(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: failedColor,
    ));
  }