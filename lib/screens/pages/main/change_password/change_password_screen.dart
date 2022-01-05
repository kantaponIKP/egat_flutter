import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/change_password/state/change_password_state.dart';
import 'package:egat_flutter/screens/pages/main/widgets/navigation_menu_widget.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _oldPasswordController;
  TextEditingController? _newPasswordController;
  TextEditingController? _confirmPasswordController;
  bool _isOldPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isValidated = false;
  // var _validate = AutovalidateMode.onUserInteraction;
  var _validate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();

    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAvatarSection(),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: _buildDescriptionSection(),
                  ),
                  SizedBox(height: 12),
                  _buildInformationSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarSection() {
    return SizedBox(
      height: 115,
      width: 115,
      child: CircleAvatar(
          backgroundColor: primaryColor, //TODO: glow
          child: Icon(Icons.lock_open, size: 60, color: whiteColor)
          // backgroundImage: AssetImage("assets/images/Profile Image.png"),
          ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(children: [
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 22),
          children: <TextSpan>[
            TextSpan(
                text:
                    '${AppLocalizations.of(context).translate('create-new-password')}'),
          ],
        ),
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text:
                    '${AppLocalizations.of(context).translate('change-password-description')}'),
          ],
        ),
      ),
    ]);
  }

  Widget _buildInformationSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          print('Card tapped.');
        },
        child: SizedBox(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              _buildForm(context),
              SizedBox(height: 32),
              _buildChangePasswordButton(),
            ]),
          )),
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      child: ElevatedButton(
        onPressed: _isValidated
            ? _onChangePasswordPressed
            : null, // null return disabled
        child: Row(
          children: [
            Spacer(),
            Text(
                '${AppLocalizations.of(context).translate('change-password')}'),
            Spacer(),
          ],
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    var model = Provider.of<ChangePasswordState>(context, listen: true);
    return Form(
      key: _formKey,
      autovalidateMode: _validate,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: TextFormField(
              obscureText: _isOldPasswordObscure,
              controller: _oldPasswordController,
              decoration: InputDecoration(
                errorText: model.info.isErrorPasswordIncorrect!
                    ? "Password incorrect"
                    : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordObscure = !_isOldPasswordObscure;
                    });
                  },
                ),
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('old-password')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return "Required";
                } else if (value.length < 6) {
                  return "Must be contain at least 6 digits";
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: TextFormField(
              obscureText: _isNewPasswordObscure,
              controller: _newPasswordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordObscure = !_isNewPasswordObscure;
                    });
                  },
                ),
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('new-password')}',
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
                  return "Password must be including UPPER/lowercase and the number";
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
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
                    '${AppLocalizations.of(context).translate('confirm-new-password')}',
              ),
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                //TODO: bug??
                if (value == null || value.trim().length == 0) {
                  return "Required";
                } else if (value.length < 6) {
                  return "Must be contain at least 6 digits";
                } else if (value != _newPasswordController!.text) {
                  return "Password doesn't match";
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

  bool _isPasswordValid(String password) {
    return RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$")
        .hasMatch(password);
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

  Future<void> _onChangePasswordPressed() async {
    bool isSuccess = false;
    var model;
    await showLoading();
    try {
      model = Provider.of<ChangePasswordState>(context, listen: false);
      isSuccess = await model.changePassword(
          _oldPasswordController!.text, _newPasswordController!.text);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
      if (isSuccess) {
        showSuccessSnackBar(context, "Change Password Successful.");
        clearText();
        // model.goToHomePage();
      }
    }
  }

  void clearText(){
    _oldPasswordController!.text = "";
    _newPasswordController!.text = "";
    _confirmPasswordController!.text = "";
  }
}
