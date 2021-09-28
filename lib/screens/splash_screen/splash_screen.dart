import 'dart:async';

import 'package:egat_flutter/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () => _navigatetoHome());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              // gradient: RadialGradient(
              //   // radius: 0.5,
              //   colors: [
              //     Colors.black,
              //     Color(0xFF303030),
              //   ],
              // ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _topScreen(),
              _centerScreen(),
              _bottomScreen(),
            ],
          )
        ],
      ),
    );
  }

  _topScreen() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              'assets/images/EGAT_logo.png',
              width: 130,
              height: 70,
            ),
          )
        ],
      ),
    );
  }

  _centerScreen() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.asset(
              'assets/images/splashscreen_logo.png',
              width: 84,
              height: 51,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: Image.asset(
              'assets/images/EGAT_mascot.png',
              width: 216,
              height: 319,
            ),
          )
        ],
      ),
    );
  }

  _bottomScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
        ),
        Text(
          'V.1.0.0',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
        )
      ],
    );
  }

  _navigatetoHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      ),
    );
  }
}
