import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/consent/privacy_policy_screen.dart';
import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:egat_flutter/screens/registration/state/user_info.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
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
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Back",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: 16,
          ),
          textAlign: TextAlign.left),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyText2!.color),
          onPressed: () => _onBackPressed()),
      centerTitle: false,
      titleSpacing: 0.0,
      leadingWidth: 32,
      elevation: 0,
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
          child: Container(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  // style: DefaultTextStyle.of(context).style,
                  style: TextStyle(fontSize: 30),
                  children: <TextSpan>[
                    TextSpan(text: 'Create'),
                    TextSpan(
                        text: ' Account',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              )),
          preferredSize: Size.fromHeight(50)),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Stack(children: <Widget>[
        Column(
          children: [
            _buildForm(context),
            _buildAdditionalSection(context),
            Spacer(),
            RegistrationAction(
              actionLabel: const Text("Next"),
              onAction: _onNextPressed,
            ),
            LoginTextButton()
          ],
        ),
      ]),
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

  Widget _buildPrivacyPolicy(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(child: Text("test")), // bottom part
        // Positioned(),// top part
      ],
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

  _displayDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // PrivacyPolicy(),
                  // Text('Hai This Is Full Screen Dialog', style: TextStyle(color: Colors.red, fontSize: 20.0),),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "DISMISS",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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
