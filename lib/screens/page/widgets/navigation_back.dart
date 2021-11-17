// import 'dart:io' show Platform;
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/sidebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class NavigationBackWidget extends StatefulWidget {
  const NavigationBackWidget({Key? key}) : super(key: key);

  @override
  _NavigationBackWidgetState createState() => _NavigationBackWidgetState();
}


class _NavigationBackWidgetState extends State<NavigationBackWidget> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Material(
            color: menuBgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              ],
            )));
  }

 
}

