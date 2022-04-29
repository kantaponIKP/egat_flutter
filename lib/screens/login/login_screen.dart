import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/main.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password.dart';
import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:egat_flutter/screens/pages/main/main_page.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/registration/registration.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/loading_clear_dialog.dart'
    as loading_clear_dialog;
import 'package:provider/provider.dart';
import 'package:egat_flutter/screens/widgets/language_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool _rememberMe = false;
  List<bool> isSelected = [true, false];
  bool _isPasswordObscure = true;
  bool _showSplashScreen = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // _emailController!.text = "prosumer19_perfectpark@email.com";
    // _passwordController!.text = "Str123";
    WidgetsBinding.instance!.addObserver(this);
        WidgetsBinding.instance!.addPostFrameCallback((_) {
      _setFontFamily();
    });
    _setIsLogin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        handleResume();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void _setFontFamily() {
    Locale _nowLocale = Localizations.localeOf(context);

    if (_nowLocale.toString() == 'th') {
      EgatApp.setAppFontFamily(context, 'Kanit');
    } else {
      EgatApp.setAppFontFamily(context, 'Montserrat');
    }
  }

  Future<void> _setIsLogin() async {
    try {
      LoginModel login = Provider.of<LoginModel>(context, listen: false);
      bool isRememberMe = await login.getRememberMe();
      if (isRememberMe) {
        if(await _autoLogin()){
          goToMainPage();
        }
      }
      setState(() {
        _showSplashScreen = false;
      });
    } catch (e) {
      showIntlException(context, e);
    } finally {}
  }

  Widget buildSplashScreen(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              child: Image.asset(
                'assets/images/splash_screen/EGAT_logo.png',
                width: 130,
                height: 70,
              ),
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
              'assets/images/splash_screen/splashscreen_logo.png',
              width: 84,
              height: 51,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            child: Image.asset(
              'assets/images/splash_screen/EGAT_mascot.png',
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
        Padding(
          padding: EdgeInsets.only(top: 20.0),
        ),
        Text(
          'Version 0.2.1',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplashScreen) {
      return buildSplashScreen(context);
    } else {
      return Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(colors: [
            Color(0xFF303030),
            Colors.black,
          ])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: _buildLoginScreen(context),
            ),
          ));
    }
  }

  Padding _buildLoginScreen(BuildContext context) {
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
    return LanguageButton();
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
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
                  return AppLocalizations.of(context)
                      .translate('validation-email');
                } else if (!_isEmailValid(value)) {
                  return AppLocalizations.of(context)
                      .translate('validation-invalidEmailAddress');
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              maxLength: 255,
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
                  return AppLocalizations.of(context)
                      .translate('validation-password');
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 50,
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

  bool _isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  Future<bool> _autoLogin() async {
    LoginModel login = Provider.of<LoginModel>(context, listen: false);
    try {
      await loading_clear_dialog.showLoading();
      await login.updateRefreshToken();
      login.isLogin = true;
      await getPersonalInformation();
    } catch (e) {
      showIntlException(context, e);
      return false;
    } finally {
      await loading_clear_dialog.hideLoading();
    }
    return true;
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        _rememberMe = newValue;
      });

  void _onLogin() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      await showLoading();
      try {
        var login = Provider.of<LoginModel>(context, listen: false);
        await login.processLogin(
            email: _emailController!.text,
            password: _passwordController!.text,
            rememberMe: _rememberMe);
        await getPersonalInformation();
        goToMainPage();
      } catch (e) {
        showIntlException(context, e);
      } finally {
        await hideLoading();
      }
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<void> handleResume() async {
    var login = Provider.of<LoginModel>(context, listen: false);
    try {
      await loading_clear_dialog.showLoading();
      await login.getRefreshToken();
      await login.updateRefreshToken(checkLogin: true);
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await loading_clear_dialog.hideLoading();
    }
  }

  Future<void> getPersonalInformation() async {
    PersonalInfoState personalInfo =
        Provider.of<PersonalInfoState>(context, listen: false);
    await personalInfo.getPersonalInformation();
  }

  void goToMainPage() {
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
