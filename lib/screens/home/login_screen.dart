// import 'package:egat_flutter/constant.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false ,
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
          _buildLogoImage(),
          _buildForm(),
          Spacer(),
          _buildLoginButton(context),
          Spacer(),
          _buildRegisterButton(context),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Email',
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
            padding: const EdgeInsets.symmetric(vertical: 4),
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

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Don't have an account ? "),
              TextButton(
                onPressed: () {},
                child: const Text('Sign Up'),
              )
            ],
          ),
          onTap: () {
            _onRegister(context);
          },
        ),
      ),
    );
  }

  void _onLogin(BuildContext context) {}

  void _onRegister(BuildContext context) {}

  _buildLogoImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 128),
        child: SvgPicture.asset("assets/images/EGATP2P.svg"),
      ),
    );
  }
}
