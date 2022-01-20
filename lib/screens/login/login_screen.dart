import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password.dart';
import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:egat_flutter/screens/page/page.dart';
import 'package:egat_flutter/screens/pages/main/main_page.dart';
import 'package:egat_flutter/screens/registration/registration.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/screens/widgets/language_button.dart';
import 'package:get_it/get_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool _rememberMe = false;
  List<bool> isSelected = [true, false];
  bool _isPasswordObscure = true;
  // bool _isLoginError = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController!.text = "prosumer04@email.com";
    _passwordController!.text = "Str123";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _autoLogin();
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
          // appBar: AppBar(),
          // drawer: NavigationMenuWidget(),
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
                  _buildLanguageButton(context),
                  Column(children: [
                    _buildLogoImage(),
                    _buildForm(context),
                    _buildAdditionalSection(context),
                    _buildAlertSection(context),
                    _buildLoginButton(context),
                  ]),
                  _buildRegisterButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context) {
    AppLocale locale = Provider.of<AppLocale>(context);
    return LanguageButton();
  }
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Icon(Icons.language),
  //       ToggleButtons(
  //         renderBorder: false,
  //         children: <Widget>[
  //           Text('TH'),
  //           Text('EN'),
  //           // Text('TH', style: TextStyle(color: Theme.of(context).primaryColor)),
  //         ],
  //         onPressed: (int index) {
  //           // appLanguage.changeLanguage(Locale("en"));
  //           locale.changeLanguage(Locale("th"));
  //           setState(() {
  //             for (int buttonIndex = 0;
  //                 buttonIndex < isSelected.length;
  //                 buttonIndex++) {
  //               if (buttonIndex == index) {
  //                 isSelected[buttonIndex] = true;
  //               } else {
  //                 isSelected[buttonIndex] = false;
  //               }
  //             }
  //           });

  //         },
  //         isSelected: isSelected,
  //       ),
  //     ],
  //   );
  // }

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
                labelText: AppLocalizations.of(context).translate('email'),
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
                labelText: AppLocalizations.of(context).translate('password'),
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
    return OverflowBar(
      alignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20.0,
              width: 20.0,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (newValue) {
                  if (newValue != null) {
                    _onRememberMeChanged(newValue);
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '${AppLocalizations.of(context).translate('remember-me')}'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: InkWell(
              child: TextButton(
            onPressed: () {
              _onForgotPasswordPressed(context);
            },
            child: Text(
              '${AppLocalizations.of(context).translate('forgot-password')}',
            ),
          )),
        ),
      ],
      // ),
    );
  }

  Widget _buildAlertSection(BuildContext context) {
    return Container(
        // TODO
        // alignment: Alignment.centerLeft,
        // padding: const EdgeInsets.only(bottom: 8.0),
        // child: Text('${AppLocalizations.of(context).translate('email-or-password-incorrect')}',
        //     style: TextStyle(color: Theme.of(context).errorColor)),
        );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
          onPressed: () {
            _onLogin();
          },
          child: Text('${AppLocalizations.of(context).translate('login')}'),
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
            Text(
                '${AppLocalizations.of(context).translate('dont-have-an-account')}'),
            TextButton(
              onPressed: () {
                _onRegister(context);
              },
              child: Text(
                  '${AppLocalizations.of(context).translate('sign-up')}',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _autoLogin() async {
    LoginModel login = Provider.of<LoginModel>(context, listen: true);
    await showLoading();
    try {
      bool isRememberMe = await login.getRememberMe();
      if (isRememberMe) {
        goToLoginPage();
        setState(() {
          _rememberMe = isRememberMe;
        });
      }
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        _rememberMe = newValue;
      });

  bool _isError() {
    LoginModel login = Provider.of<LoginModel>(context, listen: true);
    // logger.d(login.isError);
    return login.isError;
  }

  void _onLogin() async {
    FocusScope.of(context).unfocus();

    await showLoading();
    try {
      var login = Provider.of<LoginModel>(context, listen: false);
      await login.processLogin(
          email: _emailController!.text,
          password: _passwordController!.text,
          rememberMe: _rememberMe);
      goToLoginPage();
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void goToLoginPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return MainPage();
        },
      ),
    );
  }

  void _onRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Registration();
        },
      ),
    );
  }

  void _onForgotPasswordPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ForgotPassword();
        },
      ),
    );
  }

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
