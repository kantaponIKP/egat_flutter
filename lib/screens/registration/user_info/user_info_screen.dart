import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/registration/consent/privacy_policy_screen.dart';
import 'package:egat_flutter/screens/registration/widgets/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/user_info.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/signup_appbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _usernameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  bool privacyPolicy = false;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

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
              firstTitle: '${AppLocalizations.of(context).translate('create')}',
              secondTitle:
                  '${AppLocalizations.of(context).translate('account')}',
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
                        actionLabel: Text(
                            '${AppLocalizations.of(context).translate('next')}'),
                        onAction: (privacyPolicy && _isValidated)
                            ? _onNextPressed
                            : null,
                      ),
                      SizedBox(
                        height: 30.0,
                        child: RegistrationStepIndicator(),
                      ),
                      SizedBox(
                        height: 30.0,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('username')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required";
                }
                return null;
              },
              keyboardType: TextInputType.text,
              maxLength: 120,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('phone-number')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Required";
                } else if (!_isNumeric(value)) {
                  return "Must be number 10 digits";
                } else if (value.length != 10) {
                  return "Must be number 10 digits";
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              maxLength: 10,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                counterText: '',
                labelText: '${AppLocalizations.of(context).translate('email')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Required";
                } else if (!_isEmailValid(value)) {
                  return "Invalid email address";
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
              obscureText: _isPasswordObscure,
              controller: _passwordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscure = !_isPasswordObscure;
                    });
                  },
                ),
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('password')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Required";
                } else if (value.length < 6) {
                  return "Must be contain at least 6 digits";
                } else if (!_isPasswordValid(value)) {
                  return "Password must be including UPPER/lowercase and \nthe number";
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              obscureText: _isConfirmPasswordObscure,
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                    });
                  },
                ),
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('confirm-password')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Required";
                } else if (value.length < 6) {
                  return "Must be contain at least 6 digits";
                } else if (value != _passwordController!.text) {
                  return "Password doesn't match";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 120,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                    child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: Checkbox(
                            value: privacyPolicy,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                _onPrivacyPolicyChanged(newValue);
                              }
                            })),
                  ),
                ),
                TextSpan(
                    text:
                        '${AppLocalizations.of(context).translate('I-agree-to')}'),
                TextSpan(
                  text:
                      '${AppLocalizations.of(context).translate('privacy')}${AppLocalizations.of(context).translate('policy')}',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: textButton,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _onPrivacyPolicyPressed(context);
                    },
                ),
              ],
            ),
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: <Widget>[
        //       Text('I agree to the'),
        //       TextButton(
        //         onPressed: () {
        //           _onPrivacyPolicyPressed(context);
        //         },
        //         child: const Text(
        //           'Privacy Policy',
        //           style: TextStyle(
        //             decoration: TextDecoration.underline,
        //       ),
        //       //  children: []
        //       // Text('${AppLocalizations.of(context).translate('I-agree-to')}'),
        //       // TextButton(
        //       //   onPressed: () {
        //       //     _onPrivacyPolicyPressed(context);
        //       //   },
        //       //   child: Text(
        //       //     '${AppLocalizations.of(context).translate('privacy-policy')}',
        //       //     overflow: TextOverflow.clip,
        //       //     style: TextStyle(
        //       //       decoration: TextDecoration.underline,
        //       //     ),
        //       //   ),
        //       // )
        //     ],
        //   ),
        // ),
      ]
          // ),
          ),
    );
  }

  void _setValidated() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isValidated = true;
      });
    } else {
      setState(() {
        _isValidated = false;
      });
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  bool _isPasswordValid(String password){
    return RegExp(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$")
        .hasMatch(password);
  }

  void _onNextPressed() async {
    FocusScope.of(context).unfocus();

    await showLoading();
    try {
      var model = Provider.of<UserInfo>(context, listen: false);

      model.setInfo(UserInfoModel(
          username: _usernameController!.text,
          phoneNumber: _phoneNumberController!.text,
          email: _emailController!.text,
          password: _passwordController!.text));
      await model.submitUserInfo(
        username: _usernameController!.text,
        phoneNumber: _phoneNumberController!.text,
        email: _emailController!.text,
        password: _passwordController!.text,
      );
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
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

  _onPrivacyRecognizer(BuildContext context) {}
}
