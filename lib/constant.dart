import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';

const primaryColor = Color(0xffFEC908);
const backgroundColor = Colors.black;
const secondaryColor = Colors.indigo;
const neutralColor = Colors.grey;
const dangerColor = Colors.red;
const textButtonTheme = Colors.black;
const textColor = Colors.white;
const textButton = Color(0xff0DA6FC);
const whiteColor = Colors.white;
const blackColor = Colors.black;
const greyColor = Colors.grey;
final orangeColor = Colors.orange[500];

const onBgColor = Colors.white;
final surfaceColor = HexColor("#262729");
final surfaceGreyColor = HexColor("#3E3E3E");
const onSurfaceColor = Colors.white;
final contentBgColor = HexColor("#262729");
const onPrimaryBgColor = Colors.black;

final successColor = Colors.green.shade400;
final failedColor = Colors.red.shade200;
const disabledColor = Color(0xffC0C0C0);

final menuBgColor = HexColor("#3E3E3E"); //

final switchActiveColor = HexColor("#65C466");
final greenColor = HexColor("#99FF75");
final redColor = HexColor("#F6645A");

final appTitle = 'EGAT P2P';

final apiBaseUrlRegister = "https://ercapip2p.egat.co.th";
final apiBaseUrlLogin = "https://ercapip2p.egat.co.th";
final apiBaseUrlProfileManage = "https://ercapip2p.egat.co.th";
final apiBaseUrlBilateralTrade = "https://ercapip2p.egat.co.th";
// final apiBaseUrlRegister = "https://egat-p2p-api.di.iknowplus.co.th";
// final apiBaseUrlLogin = "https://egat-p2p-api.di.iknowplus.co.th";

// final apiBaseUrlProfileManage =
//     "https://egat-p2p-profile-mange.di.iknowplus.co.th/";
// final apiBaseUrlBilateralTrade =
//     "https://egat-p2p-bilateral.di.iknowplus.co.th";

final apiBaseUrlPoolMarketTrade = "https://egat-p2p-pool.di.iknowplus.co.th/";
final authorizationBase64 =
    "ZWdhdDpmYjIyN2ZlMS1mNWNhLTRjOTItYmE2My03NTg1NjQ5MTU2NTg=";
final loggerPrinter = PrettyPrinter();
final loggerLevel = Level.debug;

final Logger logger = Logger(
  printer: loggerPrinter,
  level: loggerLevel,
);
