import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/login/login_screen.dart';
import 'package:egat_flutter/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  runApp(EgatApp());
}

class EgatApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
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
    return HomeScreen();
  }
}
