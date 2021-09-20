import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool rememberMe = false;
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                // radius: 0.5,
                colors: [
              Color(0xFF303030),
              Colors.black,
            ])),
        child: Scaffold(
          //       appBar: AppBar(
          //     leading: Builder(
          //       builder: (context) =>
          //       Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: <Widget>[
          //     Icon(Icons.arrow_back_ios_new, color: Colors.white),
          //     Text('EN', style: TextStyle(color: Colors.white)),
          //   ],
          // )
          //     ),
          //   ),
          // backgroundColor: Theme.of(context).backgroundColor,
          // backgroundColor: backgroundColor,
          // backgroundColor: LinearGradient(colors: [Colors.red, Colors.blue]),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Column(
        children: [
          _buildLanguageButton(context),
          Spacer(),
          _buildLogoImage(),
          _buildForm(context),
          _buildAdditionalSection(context),
          _buildAlertSection(context),
          _buildLoginButton(context),
          Spacer(),
          _buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(Icons.language),
        ToggleButtons(
          renderBorder: false,
          children: <Widget>[
            Text('TH'),
            Text('EN'),
            // Text('TH', style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            });
          },
          isSelected: isSelected,
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Email',
                hintText: 'example@email.com',
              ),
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Require email";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Require password";
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSection(BuildContext context) {
    return Row(children: <Widget>[
      SizedBox(
        height: 20.0,
        width: 20.0,
        child: Checkbox(
          value: rememberMe,
          onChanged: (newValue) {
            if (newValue != null) {
              _onRememberMeChanged(newValue);
            }
          },
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Text('Remember me'),
      ),
      Spacer(),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
            child: TextButton(
          onPressed: () {
            _onForgotPasswordPressed(context);
          },
          child: const Text('Forgot password ?'),
        )),
      ),
    ]
        // ),
        );
  }

    Widget _buildAlertSection(BuildContext context) {
    return
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom:8.0),
        child: Text('Email or password incorrect.',style: TextStyle(color: Theme.of(context).errorColor)),
      );
  
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
          onPressed: () {
            _onLogin(context);
          },
          child: const Text("Login"),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.all(12),

            // primary: primaryColor,
            // color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Don't have an account ?"),
            TextButton(
              onPressed: () {
                _onRegister(context);
              },
              child: Text('Sign Up',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            )
          ],
        ),
      ),
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;

        if (rememberMe) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });

  void _onLogin(BuildContext context) {}

  void _onRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Registration();
        },
      ),
    );
  }

  void _onForgotPasswordPressed(BuildContext context) {}

  _buildLogoImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: SvgPicture.asset("assets/images/EGATP2P.svg"),
        ),
      ),
    );
  }
}
