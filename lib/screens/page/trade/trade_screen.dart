import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/widgets/tapbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' as Io;

class TradeScreen extends StatefulWidget {
  const TradeScreen({Key? key}) : super(key: key);

  @override
  _TradeScreenState createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen>
    with TickerProviderStateMixin {
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
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);

    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();

    _getPersonalInformation();
  }

  void _getPersonalInformation() async {
    var model = Provider.of<PersonalInfo>(context, listen: false);
    await showLoading();
    try {
      await model.getPersonalInformation();
    } catch (e) {
      showException(context, e.toString());
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
      appBar: LogoAppbar(),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
      bottomNavigationBar: PageBottomNavigationBar(),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 6),
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return
              // _buildTapbar();

              SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tapbar(),
                  _buildEnergyBalance(),
                  _buildEnergyWidgetList(),
                  // _buildEnergyWidget(),
                  Container(height: 300, child: Placeholder()),
                  _buildListTile(),
                  // _buildAvatarSection(),
                  // _buildNameSection(),
                  // SizedBox(height: 12),
                  // _buildInformationSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnergyWidgetList() {
    return
        // ListView(
        //   shrinkWrap: true,
        //   children: <Widget>[
        // _buildEnergyWidget(),
        // _buildEnergyWidget(),
        // _buildEnergyWidget(),
        // _buildEnergyWidget(),
        new Container(
      height: 84,
      child: new ListView(scrollDirection: Axis.horizontal, children: [
        _buildEnergyWidget("Today", "33.7"),
        _buildEnergyWidget("20 August 2021", "12.5"),
        _buildEnergyWidget("19 August 2021", "7.43"),
        _buildEnergyWidget("18 August 2021", "6.1"),
      ]
          // new List.generate(10, (int index) {
          //   return new Card(
          //     color: Colors.blue[index * 100],
          //     child: new Container(
          //       width: 50.0,
          //       height: 50.0,
          //       child: new Text("$index"),
          //     ),
          //   );
          // }
          ),
    );
    // ),
    // ],
  }

  Widget _buildListTile() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        // scrollDirection: Axis.horizontal,
        children: <Widget>[
          Card(
              child: CheckboxListTile(
            // tristate: true,
            title: Text('14:00-15:00'),
            secondary: Container(
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(text: "4.3 kWh"),
                    TextSpan(text: "0"),
                  ],
                ),
              ),
            ),

            // value: timeDilation != 1.0,
            controlAffinity: ListTileControlAffinity.leading,
            value: false,
            onChanged: null,
            // secondary: const Icon(Icons.hourglass_empty),
          )
              // ListTile(
              //   leading: FlutterLogo(),
              //   title: Text('One-line with leading widget'),
              // ),
              ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with leading widget'),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with leading widget'),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with leading widget'),
            ),
          ),
          Card(
            child: ListTile(
              leading: FlutterLogo(),
              title: Text('One-line with leading widget'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyWidget(String date, String amount) {
    return Card(
        // color: onBgColor,
        child: Container(
      constraints: BoxConstraints(minHeight: 72),
      width: 132,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(fontSize: 16),
                children: <TextSpan>[
                  TextSpan(text: date),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                color: onPrimaryBgColor.withAlpha(60),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    //important for overflow text
                    child: new RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                              text: amount,
                              style: TextStyle(
                                fontSize: 24,
                                color: primaryColor,
                              )),
                          new TextSpan(text: ' kWh'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildEnergyBalance() {
    return Container(
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saleable Energy (24 hr. Ahead)'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    //important for overflow text
                    child: new RichText(
                      text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                              text: "33.7",
                              style:
                                  TextStyle(fontSize: 24, color: primaryColor)),
                          new TextSpan(text: 'kWh'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(text: "Past 7-day Forecast"),
                ],
              ),
            )
          ],
        ),
      ]),
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
    print("_imageBase64");
    print(_imageBase64);
    try {
      if (_imageBase64 == null || _imageBase64 == "") {
        print("if");
        return CircleAvatar();
      } else {
        print("else");
        // return CircleAvatar(child: ClipOval(child: _image)
        return CircleAvatar(
            child: ClipOval(child: Image.memory(base64Decode(_imageBase64!)))
            // child: ClipOval(child: Image.memory(base64Decode("")))
            // backgroundImage: AssetImage("assets/images/Profile Image.png"),
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
          TextSpan(text: "Logan venial"),
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
    //   var model = Provider.of<PersonalInfo>(context, listen: false);
    //   model.setPageChangePassword();
  }

  Future<void> _onSelectPhotoPressed() async {
    //   Navigator.pop(context);
    //   XFile? xfile = await _picker.pickImage(source: ImageSource.gallery);
    //   // final bytes = await Io.File(file).readAsBytes();
    //   if (xfile == null) {
    //     return;
    //   }
    //   await showLoading();
    //   final file = File(xfile.path);
    //   final bytes = file.readAsBytesSync();
    //   String base64Image = base64Encode(bytes);
    //      log(base64Image.toString());
    //    try {
    //     var model = Provider.of<PersonalInfo>(context, listen: false);
    //     log("base print");
    //     log(base64Image);
    //     await model.changePhoto(base64Image);
    //     _getPersonalInformation();
    //   } catch (e) {
    //     showException(context, e.toString());
    //   } finally {
    //     await hideLoading();
    //   }
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
      showException(context, e.toString());
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
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }
}
