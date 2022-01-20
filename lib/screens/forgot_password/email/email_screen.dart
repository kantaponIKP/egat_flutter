import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_step_indicator.dart';
import 'package:egat_flutter/screens/forgot_password/state/email.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/registration_action.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _emailController;
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
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
                          '${AppLocalizations.of(context).translate('forgotPassword-first')}',
                      style: TextStyle(
                          // fontWeight: FontWeight.w300,
                          ),
                    ),
                    TextSpan(
                      text:
                          '${AppLocalizations.of(context).translate('forgotPassword-second')}',
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
                      _buildContent(context),
                      _buildForm(context),
                    ],
                  ),
                  Column(
                    children: [
                      RegistrationAction(
                        actionLabel: Text(
                            '${AppLocalizations.of(context).translate('send-otp')}'),
                        onAction: _isValidated ? _onSendOtpPressed : null,
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
            padding: const EdgeInsets.symmetric(vertical: 50),
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
                  return "Require email";
                } else if (!_isEmailValid(value)) {
                  return "Invalid email address";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              maxLength: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // _onLogin(context);
        },
        child:
            Text('${AppLocalizations.of(context).translate('reset-password')}'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.all(12),
          // primary: primaryColor,
          // color: Theme.of(context).primaryColor,
        ),
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

  void _onSendOtpPressed() async {
    await showLoading();
    try {
      var model = Provider.of<Email>(context, listen: false);

      model.setInfo(EmailModel(email: _emailController!.text));
      // model.nextPage();
      // await model.submitUserInfo(
      //   fullName: _fullNameController!.text,
      //   phoneNumber: _phoneNumberController!.text,
      //   email: _emailController!.text,
      //   password: _passwordController!.text,
      // );
      await model.sendOtp(email: _emailController!.text);
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onBackPressed() {
    var model = Provider.of<Email>(context, listen: false);
    model.backPage();
  }
}
