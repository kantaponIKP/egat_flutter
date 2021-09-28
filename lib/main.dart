import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  PreferredAppLanguage preferredAppLanguage =
      await PreferredAppLanguage.createInstance();

  runApp(EgatApp(preferredAppLanguage: preferredAppLanguage));
}

class EgatApp extends StatelessWidget {
  PreferredAppLanguage preferredAppLanguage;

  EgatApp({
    required this.preferredAppLanguage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLocale>(
          create: (context) {
            var appLocale =
                AppLocale.fromPreferredAppLanguage(preferredAppLanguage);

            return appLocale;
          },
        ),
      ],
      child: Consumer<AppLocale>(
        builder: (context, provider, child) {
          return MaterialApp(
            supportedLocales: [
              Locale('en', 'US'),
              Locale('th'),
            ],
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
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              buttonTheme: ButtonThemeData(
                buttonColor: primaryColor,
                shape: RoundedRectangleBorder(),
                // textTheme: ButtonTextTheme.accent,
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
                ),
              ),
              iconTheme: IconThemeData(color: textColor),
              textTheme: TextTheme(
                bodyText2: TextStyle(color: textColor,),
                subtitle1:
                    //TextFormField textStyle
                    TextStyle(color: textColor,),
              ),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(textButton),
                ),
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
                ),
              ),
              toggleButtonsTheme: ToggleButtonsThemeData(
                selectedColor: primaryColor,
                color: textColor,
                fillColor: Colors.transparent,
              ),
            ),
            home: EgatHomePage(title: appTitle),
            builder: EasyLoading.init(),
            locale: provider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

class EgatHomePage extends StatefulWidget {
  final String title;

  EgatHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _EgatHomePageState createState() => _EgatHomePageState();
}

class _EgatHomePageState extends State<EgatHomePage> {
  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}
