import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _fullNameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailController;
  final ImagePicker _picker = ImagePicker();
  XFile? _file;
  String? _fullName;
  String? _phoneNumber;
  String? _email;
  bool _isValidated = false;
  bool _isFormChanged = false;
  Image? _image;
  String? _imageBase64;

  @override
  void initState() {
    super.initState();

    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();

    _getPersonalInformation();
  }

  void _getPersonalInformation() async {
    var model = Provider.of<PersonalInfo>(context, listen: false);
    await showLoading();
    try {
      if(model.info.fullName == null){
        await model.getPersonalInformation();
      }
    } catch (e) {
      showIntlException(context, e);
    } finally {
      if (model.info.fullName != null) {
        _fullNameController!.text = model.info.fullName!;
        _fullName = model.info.fullName!;
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
      appBar: PageAppbar(firstTitle: "Personal", secondTitle: "Information"),
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
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: new Icon(Icons.photo),
                              title: new Text('Select Photo'),
                              onTap: () {
                                _onSelectPhotoPressed();
                              },
                            ),
                            ListTile(
                              leading: new Icon(Icons.delete_outline),
                              title: new Text('Remove Photo'),
                              onTap: () {
                                _onPressedRemovePhoto();
                              },
                            ),
                          ],
                        );
                      });
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

  Widget _buildAvatar() {
    try{
      if (_imageBase64 == null || _imageBase64 == "") {
          return CircleAvatar();
        } else {
          return CircleAvatar(
              child: ClipOval(child: Image.memory(base64Decode(_imageBase64!)))
              );
        }
    }catch (e){
      return CircleAvatar();
    }
  
  }

  Widget _buildNameSection() {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 22),
        children: <TextSpan>[
          TextSpan(text: _fullNameController!.text),
        ],
      ),
    );
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
              SizedBox(height: 18),
              _buildChangePasswordButton(),
              SizedBox(height: 32),
              _buildSubmitButton(),
            ]),
          )),
        ),
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
              controller: _fullNameController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('full-name')}',
              ),
              onChanged: (newValue) {
                _setValidated();
                _setIsFormChanged();
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
                  return "Required";
                } else if (!_isEmailValid(value)) {
                  return "Invalid email address";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              maxLength: 120,
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
    if (_fullNameController!.text != _fullName ||
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
    var model = Provider.of<PersonalInfo>(context, listen: false);
    model.setPageChangePassword();
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
      var model = Provider.of<PersonalInfo>(context, listen: false);
      await model.changePhoto(base64Image);
      _getPersonalInformation();
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
      var model = Provider.of<PersonalInfo>(context, listen: false);
      await model.removePhoto();
      _getPersonalInformation();
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
      var model = Provider.of<PersonalInfo>(context, listen: false);
      await model.changePersonalInformation(
          fullName: _fullNameController!.text,
          phoneNumber: _phoneNumberController!.text,
          email: _emailController!.text);
      _getPersonalInformation();
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
