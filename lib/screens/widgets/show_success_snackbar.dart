import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: <Widget>[
      CircleAvatar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade400,
        // radius: screenSize.width * 0.15,
        radius: 12,
        child: new Icon(Icons.check, color: Colors.white, size: 16),
      ),
      SizedBox(width: 6),
      Expanded(child: Text(message, style: TextStyle(color: textColor)))
    ]),
    elevation: 8.0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: successColor,
  ));
}

