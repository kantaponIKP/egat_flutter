import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/registration/widgets/signup_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeterScreen extends StatefulWidget {
  const MeterScreen({Key? key}) : super(key: key);

  @override
  _MeterScreenState createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _meterController;
  TextEditingController? _meterIDController;
  TextEditingController? _locationController;
  bool prosumer = false;
  bool aggregator = false;
  bool consumer = false;

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
          appBar: SignupAppbar(firstTitle: 'Create', secondTitle: 'Account', onAction: _onBackPressed),
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
                        actionLabel: const Text("Next"),
                        onAction: _onNextPressed,
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _meterController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Meter',
              ),
              keyboardType: TextInputType.text,
              maxLength: 24,
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
                    labelText: 'Meter id',
                    errorText: "Already used"
                  ),
                  keyboardType: TextInputType.text,
                  maxLength: 24,
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
              controller: _locationController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Location',
              ),
              keyboardType: TextInputType.text,
              maxLength: 24,
            ),
          ),
        ],
      ),
    );
  }

    Widget _checkButton() {
    return ElevatedButton(
      style: TextButton.styleFrom(
      ),
      onPressed: () {},
      child: const Text('Check')
    );
  }

  Widget _successButton() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.lightGreenAccent.shade400,
      ),
      onPressed: () {},
      child: const Icon(Icons.check, color: Colors.white, size: 30),
    );
  }

  Widget _buildAdditionalSection(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            alignment: Alignment.centerLeft,
            child: Text("Role", style: TextStyle(fontSize: 20))),
        Row(children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: Checkbox(
              value: prosumer,
              onChanged: (newValue) {
                if (newValue != null) {
                  _onProsumerChanged(newValue);
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text('Prosumer'),
          ),
        ]),
        Row(children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: Checkbox(
              value: aggregator,
              onChanged: (newValue) {
                if (newValue != null) {
                  _onAggregatorChanged(newValue);
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text('Aggregator'),
          ),
        ]),
        Row(children: <Widget>[
          SizedBox(
            height: 20.0,
            width: 20.0,
            child: Checkbox(
              value: consumer,
              onChanged: (newValue) {
                if (newValue != null) {
                  _onConsumerChanged(newValue);
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text('Consumer'),
          ),
        ]),
      ],
    );
  }

  void _onNextPressed() {
    var model = Provider.of<Meter>(context, listen: false);
    model.nextPage();
  }

  void _onBackPressed() {
    var model = Provider.of<Meter>(context, listen: false);
    model.backPage();
  }

  void _onProsumerChanged(bool newValue) => setState(() {
        prosumer = newValue;
        // TODO
      });
  void _onAggregatorChanged(bool newValue) => setState(() {
        aggregator = newValue;
        // TODO
      });
  void _onConsumerChanged(bool newValue) => setState(() {
        consumer = newValue;
        // TODO
      });
}
