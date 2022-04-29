import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/registration/widgets/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/signup_appbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeterScreen extends StatefulWidget {
  const MeterScreen({Key? key}) : super(key: key);

  @override
  _MeterScreenState createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _meterNameController;
  TextEditingController? _meterIDController;
  TextEditingController? _locationController;
  int? _role;
  bool _isValidated = false;

  void _handleRadioValueChange(int? value) {
    setState(() {
      _role = value!;

      switch (_role) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _meterNameController = TextEditingController();
    _meterIDController = TextEditingController();
    _locationController = TextEditingController();
    _getInfo();
  }

  void _getInfo() {
    var meter = Provider.of<Meter>(context, listen: false);
    if (meter.info.meterName != null) {
      _meterNameController!.text = meter.info.meterName!;
    }
    if (meter.info.meterId != null) {
      _meterIDController!.text = meter.info.meterId!;
    }
    if (meter.info.location != null) {
      _locationController!.text = meter.info.location!;
    }
    if (meter.info.roleIndex != null) {
      _role = meter.info.roleIndex!;
    } else {
      _role = 0;
    }
    if(meter.info.meterName != null && meter.info.meterId != null && meter.info.location != null){
      _isValidated = true;
    }
    // if (meter.info.status != null) {
    //   _locationController!.text = meter.info.status;
    // }
    // if (meter.info.status != null) {
    //   meter.updateInfo(status: MeterStatus.Uncheck);
    // }
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
          // appBar: _buildAppBar(context),
          appBar: SignupAppbar(
              firstTitle: '${AppLocalizations.of(context).translate('createAccount-first')}',
              secondTitle:
                  '${AppLocalizations.of(context).translate('createAccount-second')}',
              onAction: _onBackPressed),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  Padding _buildAction(BuildContext context) {
    var meter = Provider.of<Meter>(context, listen: false);
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
                        onAction: _isValidated &&
                                meter.info.status == MeterStatus.Checked
                            ? _onNextPressed
                            : null,
                      ),
                      SizedBox(
                        height: 30.0,
                        child: RegistrationStepIndicator(),
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

  Widget _buildForm(BuildContext context) {
    var meter = Provider.of<Meter>(context, listen: true);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _meterNameController,
              decoration: InputDecoration(
                counterText: '',
                labelText: '${AppLocalizations.of(context).translate('meter-name')}',
              ),
              keyboardType: TextInputType.text,
              maxLength: 50,
              onChanged: (newValue) {
                _setValidated();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)
                      .translate('validation-required');
                }
                return null;
              },
            ),
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: _meterIDController,
                  decoration: InputDecoration(
                      counterText: '',
                      labelText:
                          '${AppLocalizations.of(context).translate('meter-id')}',
                      errorText: meter.info.errorText),
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                      .translate('validation-required');
                    } else if (value.length != 8 && value.length != 10) {
                      return AppLocalizations.of(context).translate('validation-mustBeContain-8or10digits');
                    }
                    return null;
                  },
                  onChanged: (text) {
                    if (meter.info.status == MeterStatus.Checked) {
                      meter.updateInfo(
                          // errorText: 'Already used',
                          status: MeterStatus.Uncheck,
                          location: '');
                    }
                    _locationController!.text = '';
                  },
                ),
              ),
              Positioned.fill(
                  top: 16,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: _checkButton(),
                  ))
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              enabled: false,
              maxLines: null,
              controller: _locationController,
              decoration: InputDecoration(
                counterText: '',
                labelText:
                    '${AppLocalizations.of(context).translate('location')}',
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.bodyText2!.color!,
                  ),
                ),
              ),
              keyboardType: TextInputType.text,
              maxLength: 255,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkButton() {
    var meter = Provider.of<Meter>(context, listen: true);
    if (meter.info.status == MeterStatus.Checked) {
      return ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.lightGreenAccent.shade400,
        ),
        onPressed: () {},
        child: const Icon(Icons.check, color: Colors.white, size: 30),
      );
    } else {
      return ElevatedButton(
          style: TextButton.styleFrom(),
          onPressed: () {
            _onCheckPressed();
          },
          child: Text('${AppLocalizations.of(context).translate('check')}'));
    }
  }

  Widget _buildAdditionalSection(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            alignment: Alignment.centerLeft,
            child: Text('${AppLocalizations.of(context).translate('role')}',
                style: TextStyle(fontSize: 20))),
        Row(children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: new Radio(
              value: 0,
              groupValue: _role,
              onChanged: _handleRadioValueChange,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('${AppLocalizations.of(context).translate('prosumer')}'),
          ),
        ]),
        Row(children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: new Radio(
              value: 1,
              groupValue: _role,
              onChanged: _handleRadioValueChange,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('${AppLocalizations.of(context).translate('aggregator')}'),
          ),
        ]),
        Row(children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: new Radio(
              value: 2,
              groupValue: _role,
              onChanged: _handleRadioValueChange,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('${AppLocalizations.of(context).translate('consumer')}'),
          ),
        ]),
      ],
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

  void _onCheckPressed() async {
    // FocusScope.of(context).unfocus();
    // print(_meterIDController!.text);
    if(_meterIDController!.text.length != 8 && _meterIDController!.text.length != 10) {
      return; //validate meter id
    }
    await showLoading();
    try {
      var model = Provider.of<Meter>(context, listen: false);

      await model.getLocation(meterId: _meterIDController!.text);
      // Todo
      if (_locationController == null) {
      } else {
        _locationController!.text = model.info.location!;
      }
      _setValidated();
    } catch (e) {
      showIntlException(context, e);
      logger.d(e.toString());
    } finally {
      await hideLoading();
    }
  }

  void _onNextPressed() {
    var model = Provider.of<Meter>(context, listen: false);
    model.setInfo(
      MeterModel(
        meterName: _meterNameController!.text,
        meterId: _meterIDController!.text,
        location: _locationController!.text,
        roleIndex: _role,
        role: model.getRoleFromIndex(_role!),
        zoomLevel: model.info.zoomLevel,
        latitude: model.info.latitude,
        longtitude: model.info.longtitude,
        status: model.info.status,
      ),
    );
    model.nextPage();
    // logger.d("nextPagePressed");
  }

  void _onBackPressed() {
    var model = Provider.of<Meter>(context, listen: false);
    model.backPage();
  }
}
