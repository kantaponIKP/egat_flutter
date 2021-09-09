import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/home/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  runApp(EgatApp());
}

class EgatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
          // brightness: Brightness.dark,
          // primarySwatch: primaryColor,
          backgroundColor: backgroundColor,
          primaryColor: primaryColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              onPrimary: textButtonTheme,
              primary: primaryColor,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.accent,
          ),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: textTheme),
            button: TextStyle(color: primaryColor),
            subtitle1: TextStyle(color: textTheme), //TextFormField textStyle
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(primaryColor)),
          ),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: textTheme,
              ),
              fillColor: textTheme,
              // inputBorder:
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: textTheme,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              ))),
      home: EgatHomePage(title: appTitle),
      builder: EasyLoading.init(),
    );
  }
}

class EgatHomePage extends StatefulWidget {
  EgatHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EgatHomePageState createState() => _EgatHomePageState();
}

class _EgatHomePageState extends State<EgatHomePage> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
