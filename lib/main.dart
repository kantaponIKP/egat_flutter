import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/login/login_screen.dart';
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
          fontFamily: 'Montserrat',
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  foregroundColor: MaterialStateProperty.all(backgroundColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0),
                  )))),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.accent,
          ),
          checkboxTheme: CheckboxThemeData(
              checkColor: MaterialStateProperty.all(backgroundColor),
              fillColor: MaterialStateColor.resolveWith(
                (states) {
                  if (states.contains(MaterialState.selected)) {
                    return primaryColor; // the color when checkbox is selected;
                  }
                  return Colors.grey; //the color when checkbox is unselected;
                },
              )),
          iconTheme: IconThemeData(color: textColor),
          textTheme: TextTheme(
            bodyText2: TextStyle(color: textColor),
            subtitle1: TextStyle(color: textColor), //TextFormField textStyle
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(textButton)),
            // Sign up and login should to implement directly
          ),
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                color: textColor.withAlpha(150),
              ),
              labelStyle: TextStyle(
                color: textColor,
              ),
              fillColor: textColor,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: textColor,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                ),
              )),
          toggleButtonsTheme: ToggleButtonsThemeData(
            selectedColor: primaryColor,
            color: textColor,
            fillColor: Colors.transparent,
          )),
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
