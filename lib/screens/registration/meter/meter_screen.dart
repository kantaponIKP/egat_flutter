import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MeterScreen extends StatefulWidget {
  const MeterScreen({Key? key}) : super(key: key);

  @override
  _MeterScreenState createState() => _MeterScreenState();
}

class _MeterScreenState extends State<MeterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _fullNameController;
  TextEditingController? _phoneNumberController;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
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
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Back",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: 16,
          ),
          textAlign: TextAlign.left),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyText2!.color),
          onPressed: () => _onBackPressed()),
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
                    TextSpan(text: 'Create'),
                    TextSpan(
                        text: ' Account',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              )),
          preferredSize: Size.fromHeight(50)),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Column(
        children: [
          _buildForm(context),
          _buildAdditionalSection(context),
          Spacer(),
          RegistrationAction(
            actionLabel: const Text("Next"),
            onAction: _onNextPressed,
          ),
          LoginTextButton()
        ],
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
              controller: _fullNameController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Meter',
              ),
              keyboardType: TextInputType.text,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Meter id',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 24,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                counterText: '',
                labelText: 'Location',
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 24,
            ),
          ),
        ],
      ),
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
