import 'dart:developer';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  SimpleDialog build(BuildContext context) {
    return SimpleDialog(
        backgroundColor: contentBgColor,
        contentPadding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        title: _buildTitle(context),
        children: [_buildAction(context)]);
  }

  Widget _buildTitle(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
      RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
            TextSpan(text: "Contact", style: TextStyle(fontSize: 20)),
            TextSpan(
                text: " Us",
                style: TextStyle(fontSize: 20, color: primaryColor)),
          ])),
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            color: white,
          ))
    ]);
  }

  Widget _buildAction(context) {
    return Container(
      child: Column(
        children: [
          _buildIconWithTextList(Icons.phone, "Tel. 089-xxx-xxxx"),
          SizedBox(height: 8),
          _buildIconWithTextList(Icons.mail, "egat.p2p@gmail.com"),
          SizedBox(height: 8),
          _buildIconWithTextList(Icons.location_on, "123 Street 123 Road"),
        ],
      ),
    );
  }

  _buildIconWithTextList(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(text),
        ),
      ],
    );
  }
}
