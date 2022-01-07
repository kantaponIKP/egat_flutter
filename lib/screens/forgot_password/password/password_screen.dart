import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_step_indicator.dart';
import 'package:egat_flutter/screens/forgot_password/state/password.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/registration_action.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context).translate('back'),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: 16,
          ),
          textAlign: TextAlign.left),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyText2!.color),
          onPressed: () => Navigator.pop(context)),
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
                    TextSpan(
                      text:
                          '${AppLocalizations.of(context).translate('forgot')}',
                      style: TextStyle(
                          // fontWeight: FontWeight.w300,
                          ),
                    ),
                    TextSpan(
                      text:
                          '${AppLocalizations.of(context).translate('password')}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        // fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )),
          preferredSize: Size.fromHeight(50)),
    );
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
                    ],
                  ),
                  Column(
                    children: [
                      RegistrationAction(
                        actionLabel: Text(
                            '${AppLocalizations.of(context).translate('reset-password')}'),
                        onAction: _isValidated ? _onResetPasswordPressed : null,
                      ),
                      SizedBox(
                        height: 30.0,
                        child: ForgotPasswordStepIndicator(),
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

  Widget _buildContent(BuildContext context) {
    return Container(
      child: Text(
          '${AppLocalizations.of(context).translate('forgot-password-paragraph')}',
          style: TextStyle(fontSize: 16)),
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
                  return "Password do not match";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 24,
            ),
          ),
        ],
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

    bool _isPasswordValid(String password){
    return RegExp(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$")
        .hasMatch(password);
  }

  void _onResetPasswordPressed() async {
    await showLoading();

    try {
      var model = Provider.of<Password>(context, listen: false);
      await model.resetPassword(_passwordController!.text);
      var forgotPasswordModel =
          Provider.of<ForgotPasswordModel>(context, listen: false);
      showSuccessSnackBar(context,AppLocalizations.of(context).translate('message-changePasswordSuccessfully'));
      // ScaffoldMessenger.of(context).clearSnackBars();
      
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(message),
      // ));
      forgotPasswordModel.finish();
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onBackPressed() {
    var model = Provider.of<Password>(context, listen: false);
    model.backPage();
  }
}
