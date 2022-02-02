import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/login/login.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/notification_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();

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
        ChangeNotifierProvider<LoginSession>(
          create: (context) {
            return LoginSession();
          },
        ),
        ChangeNotifierProxyProvider<LoginSession, PersonalInfoState>(
          create: (_) => PersonalInfoState(),
          update: (_, loginSession, personalInfoState) {
            if (personalInfoState == null) {
              personalInfoState = PersonalInfoState();
            }

            return personalInfoState..setLoginSession(loginSession);
          },
        ),
        ChangeNotifierProxyProvider<LoginSession, PinState>(
          create: (context) {
            var loginSession =
                Provider.of<LoginSession>(context, listen: false);
            return PinState(loginSession: loginSession);
          },
          update: (context, LoginSession value, PinState? previous) {
            if (previous == null) {
              return PinState(loginSession: value);
            } else {
              previous.setLoginSession(value);
              return previous;
            }
          },
        ),
        ChangeNotifierProxyProvider<LoginSession, NotificationState>(
          create: (context) {
            var loginSession =
                Provider.of<LoginSession>(context, listen: false);
            return NotificationState(loginSession: loginSession);
          },
          update: (context, LoginSession value, NotificationState? previous) {
            if (previous == null) {
              return NotificationState(loginSession: value);
            } else {
              previous.setLoginSession(value);
              return previous;
            }
          },
        ),
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
            navigatorKey: navigatorKey,
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
              scaffoldBackgroundColor: backgroundColor,
              primaryColor: primaryColor,
              // fontFamily:
                  // AppLocalizations.of(context).getLocale().toString() == 'th'
                  //     ? 'Kanit'
                  //     : 'Montserrat',
                  // fontFamily: 'Kanit',
                      fontFamily: 'Montserrat',
              canvasColor: surfaceColor, //dropdown color
              unselectedWidgetColor: Colors.white,
              radioTheme: RadioThemeData(
                  fillColor: MaterialStateProperty.all(primaryColor)),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return primaryColor.withOpacity(0.5);
                      else if (states.contains(MaterialState.disabled))
                        return disabledColor;
                      return primaryColor;
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return textButtonTheme.withOpacity(0.5);
                      else if (states.contains(MaterialState.disabled))
                        return textColor;
                      return textButtonTheme;
                    },
                  ),
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
              dialogTheme: DialogTheme(
                backgroundColor: surfaceColor,
                titleTextStyle: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                ),
              ),
              iconTheme: IconThemeData(
                color: textColor,
              ),
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
                subtitle1: TextStyle(
                  color: textColor,
                ),
                bodyText1: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: textColor,
                ),
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
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Builder(
                  builder: (context) => EasyLoading.init()(context, child),
                ),
              );
            },
            locale: provider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
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
    return Login();
  }
}
