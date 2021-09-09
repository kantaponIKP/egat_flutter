import 'package:egat_flutter/constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:egat_flutter/screens/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildAction(context),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        children: [
          Spacer(flex: 2),
          // _buildLogoImage(),
          Spacer(),
          _buildLoginButton(context),
          _buildRegisterButton(context),
          Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            _onRegister(context);
          },
          child: const Text(
            "ลงทะเบียน",
            style: TextStyle(color: primaryColor),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _onLogin(context);
        },
        child: const Text("เข้าสู่ระบบ"),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.all(12),
        ),
      ),
    );
  }

  void _onRegister(BuildContext context) {}

  void _onLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
         return LoginScreen();
      })
    );
  }

  _buildLogoImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 64),
        // child: Image.asset("assets/images/iknow-logo-white-screen.png"),
      ),
    );
  }
}
