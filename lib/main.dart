import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/home/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:egat_flutter/i18n/app_language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(EgatApp(appLanguage: appLanguage));
}

class EgatApp extends StatelessWidget {
  final AppLanguage appLanguage;

  EgatApp({required this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          supportedLocales: [
            Locale('en', 'US'), 
            Locale('th')],
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
                bodyText2: TextStyle(color: white),
                button: TextStyle(color: primaryColor),
                subtitle1: TextStyle(color: white), //TextFormField textStyle
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(primaryColor)),
              ),
              inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(
                    color: white,
                  ),
                  fillColor: white,
                  // inputBorder:
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: white,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ))),
          home: EgatHomePage(title: appTitle),
          builder: EasyLoading.init(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      }),
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
