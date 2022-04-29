import 'dart:convert';
import 'dart:io';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _usernameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailController;
  final ImagePicker _picker = ImagePicker();
  String? _username;
  String? _phoneNumber;
  String? _email;
  bool _isValidated = false;
  bool _isFormChanged = false;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();

    _getInformation();
  }

  void _getInformation() async {
    var model = Provider.of<PersonalInfoState>(context, listen: false);

    if (model.info.username == null) {
      await model.getPersonalInformation();
    } else {
      if (model.info.username != null) {
        _usernameController!.text = model.info.username!;
        _username = model.info.username!;
      }
      if (model.info.phoneNumber != null) {
        _phoneNumberController!.text = model.info.phoneNumber!;
        _phoneNumber = model.info.phoneNumber!;
      }
      if (model.info.email != null) {
        _emailController!.text = model.info.email!;
        _email = model.info.email!;
      }
      if (model.info.photo != null) {
        setState(() {
          _imageBase64 = model.info.photo!;
        });
      }
    }
  }

  void _getPersonalInformation() async {
    var model = Provider.of<PersonalInfoState>(context, listen: false);

    try {
      await showLoading();
      await model.getPersonalInformation();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      if (model.info.username != null) {
        _usernameController!.text = model.info.username!;
        _username = model.info.username!;
      }
      if (model.info.phoneNumber != null) {
        _phoneNumberController!.text = model.info.phoneNumber!;
        _phoneNumber = model.info.phoneNumber!;
      }
      if (model.info.email != null) {
        _emailController!.text = model.info.email!;
        _email = model.info.email!;
      }
      if (model.info.photo != null) {
        setState(() {
          _imageBase64 = model.info.photo!;
        });
      }
      await hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF303030),
                Colors.black,
              ],
            ),
          ),
          child: _buildAction(context),
        ),
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
                  _buildNameSection(),
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
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          _buildAvatar(),
          Positioned(
              bottom: 0,
              right: -25,
              child: RawMaterialButton(
                onPressed: () {
                  onCameraPressed(context);
                },
                elevation: 1.0,
                fillColor: surfaceColor.withAlpha(0),
                child: Icon(
                  Icons.camera_alt,
                ),
                padding: EdgeInsets.all(6.0),
                shape: CircleBorder(),
              )),
        ],
      ),
    );
  }

  void onCameraPressed(BuildContext context) {
    if (Platform.isIOS) {
      showIOSActionSheet(context);
    } else {
      showAndriodActionSheet(context);
    }
  }

  showAndriodActionSheet(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: whiteColor,
        context: context,
        builder: buildAndroidActionSheet);
  }

  showIOSActionSheet(BuildContext context) {
    return showCupertinoModalPopup(
        context: context, builder: buildIOSActionSheet);
  }

  Widget buildAndroidActionSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          tileColor: whiteColor,
          leading: new Icon(Icons.photo, color: blackColor),
          title: new Text(
            AppLocalizations.of(context).translate('message-photo-selectPhoto'),
            style: TextStyle(color: blackColor),
          ),
          onTap: () {
            _onSelectPhotoPressed();
          },
        ),
        ListTile(
          tileColor: whiteColor,
          leading: new Icon(Icons.delete_outline, color: redColor),
          title: new Text(
            AppLocalizations.of(context).translate('message-photo-removePhoto'),
            style: TextStyle(color: redColor),
          ),
          onTap: () {
            _onPressedRemovePhoto();
          },
        ),
      ],
    );
  }

  Widget buildIOSActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            _onSelectPhotoPressed();
          },
          child: Text(
            AppLocalizations.of(context).translate('message-photo-selectPhoto'),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            _onPressedRemovePhoto();
          },
          child: Text(
            AppLocalizations.of(context).translate('message-photo-removePhoto'),
          ),
          isDestructiveAction: true,
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(AppLocalizations.of(context).translate('cancel')),
      ),
    );
  }

  Widget _buildAvatar() {
    try {
      if (_imageBase64 == null || _imageBase64 == "") {
        return CircleAvatar();
      } else {
        return CircleAvatar(
          child: ClipOval(
            child: Image.memory(
              base64Decode(_imageBase64!),
              width: 115,
              height: 115,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    } catch (e) {
      return CircleAvatar();
    }
  }

  Widget _buildNameSection() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 22),
        children: <TextSpan>[
          TextSpan(text: _username),
        ],
      ),
    );
  }

  Widget _buildInformationSection() {
    return Card(
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            _buildForm(context),
            SizedBox(height: 18),
            _buildChangePasswordButton(),
            SizedBox(height: 32),
            _buildSubmitButton(),
          ]),
        )),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text:
                '${AppLocalizations.of(context).translate('change-password')}',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: textButton,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _onChangePasswordPressed();
              },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      child: ElevatedButton(
        onPressed: _isValidated && _isFormChanged
            ? _onPressedSubmit
            : null, // null return disabled
        child: Row(
          children: [
            Spacer(),
            Text('${AppLocalizations.of(context).translate('submit')}'),
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
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('username')}',
              ),
              onChanged: (newValue) {
                _setValidated();
                _setIsFormChanged();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).translate('validation-required');
                }
                return null;
              },
              keyboardType: TextInputType.text,
              maxLength: 50,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('phone-number')}',
              ),
              onChanged: (newValue) {
                _setValidated();
                _setIsFormChanged();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return AppLocalizations.of(context)
                      .translate('validation-required');
                } else if (!_isNumeric(value)) {
                  return AppLocalizations.of(context).translate('validation-mustBeContain-10digits');
                } else if (value.length != 10) {
                  return AppLocalizations.of(context).translate('validation-mustBeContain-10digits');
                }
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              maxLength: 10,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                counterText: '',
                labelText: '${AppLocalizations.of(context).translate('email')}',
              ),
              onChanged: (newValue) {
                _setValidated();
                _setIsFormChanged();
              },
              validator: (value) {
                if (value == null || value.trim().length == 0) {
                  return AppLocalizations.of(context).translate('validation-required');
                } else if (!_isEmailValid(value)) {
                  return AppLocalizations.of(context).translate('validation-invalidEmailAddress');
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              maxLength: 255,
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

  void _setIsFormChanged() {
    if (_usernameController!.text != _username ||
        _phoneNumberController!.text != _phoneNumber ||
        _emailController!.text != _email) {
      setState(() {
        _isFormChanged = true;
      });
    } else {
      setState(() {
        _isFormChanged = false;
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

  void _onChangePasswordPressed() {
    // var model = Provider.of<PersonalInfoState>(context, listen: false);
    // model.setPageChangePassword();
    MainScreenNavigationState mainScreenNavigation =
        Provider.of<MainScreenNavigationState>(context, listen: false);
    mainScreenNavigation.setPageToChangePassword();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleTwoTitles(
        title: AppLocalizations.of(context)
            .translate('title-changePassword-first'),
        secondaryTitle: AppLocalizations.of(context)
            .translate('title-changePassword-second'));
  }

  Future<void> _onSelectPhotoPressed() async {
    Navigator.pop(context);
    XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
    // final bytes = await Io.File(file).readAsBytes();
    if (xfile == null) {
      return;
    }
    await showLoading();
    final file = File(xfile.path);
    final bytes = file.readAsBytesSync();
    String base64Image = base64Encode(bytes);
    try {
      var model = Provider.of<PersonalInfoState>(context, listen: false);
      await model.changePhoto(base64Image);
      _getPersonalInformation();
      showSuccessSnackBar(context,
          AppLocalizations.of(context).translate('message-changeSuccessfully'));
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onPressedRemovePhoto() async {
    Navigator.pop(context);
    // FocusScope.of(context).unfocus();

    await showLoading();
    try {
      var model = Provider.of<PersonalInfoState>(context, listen: false);
      await model.removePhoto();
      _getPersonalInformation();
      showSuccessSnackBar(context,
          AppLocalizations.of(context).translate('message-changeSuccessfully'));
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onPressedSubmit() async {
    FocusScope.of(context).unfocus();

    await showLoading();
    try {
      var model = Provider.of<PersonalInfoState>(context, listen: false);
      await model.changePersonalInformation(
          username: _usernameController!.text,
          phoneNumber: _phoneNumberController!.text,
          email: _emailController!.text);
      _getPersonalInformation();
      showSuccessSnackBar(context,
          AppLocalizations.of(context).translate('message-changeSuccessfully'));
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }
}

// class PersonalInfoModel{
//   String? fullName;
//   String? phoneNumber;
//   String? email;
// }
