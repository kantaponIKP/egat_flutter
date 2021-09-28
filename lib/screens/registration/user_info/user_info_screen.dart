import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/consent/privacy_policy_screen.dart';
import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/user_info.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/signup_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _fullNameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool privacyPolicy = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          Color(0xFF303030),
          Colors.black,
        ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: SignupAppbar(
              firstTitle: 'Create',
              secondTitle: 'Account',
              onAction: _onBackPressed),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      _buildForm(context),
                      _buildAdditionalSection(context),
                    ],
                  ),
                  Column(
                    children: [
                      RegistrationAction(
                        actionLabel: const Text("Next"),
                        onAction: _onNextPressed,
                      ),
                      SizedBox(
                        height: 30.0,
                        child: RegistrationStepIndicator(),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: LoginTextButton(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
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
              controller: _fullNameController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Full name',
              ),
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Require email";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Phone number',
              ),
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Require email";
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
          value: privacyPolicy,
          onChanged: (newValue) {
            if (newValue != null) {
              _onPrivacyPolicyChanged(newValue);
            }
          },
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text('I agree to the'),
            TextButton(
              onPressed: () {
                _onPrivacyPolicyPressed(context);
              },
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ),
    ]
        // ),
        );
  }

  void _onNextPressed() {
    var model = Provider.of<UserInfo>(context, listen: false);
    model.nextPage();
  }

  void _onBackPressed() {
    Navigator.pop(context);
    // TODO
  }

  void _onPrivacyPolicyPressed(BuildContext context) {
    // _displayDialog(context);
    showDialog(
        context: context,
        builder: (context) {
          return PrivacyPolicy();
        });
  }

  void _onPrivacyPolicyChanged(bool newValue) => setState(() {
        privacyPolicy = newValue;
        if (privacyPolicy) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });
}
