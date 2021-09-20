import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class SuccessScreen extends StatefulWidget {
  SuccessScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final _formKey = GlobalKey<FormState>();

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
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Stack(children: <Widget>[
        Column(
          children: [
            Spacer(),
            _buildSuccessLogo(context),
            SizedBox(height: 32),
            _buildForm(context),
            Spacer(),
            RegistrationAction(
              actionLabel: const Text("Next"),
              onAction: _onBackToLoginPressed,
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
        child: Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
            text: "Thanks! Your account has been successfully created.",
            style: TextStyle(fontSize: 20, color: Colors.green.shade400)),
      ),
    ));
  }

  Widget _buildSuccessLogo(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return FittedBox(
        // child: Icon(
        //   Icons.done_rounded,
        //   color: Colors.green.shade400,
        // ),
        child: CircleAvatar(
      backgroundColor: Colors.green.shade400,
      radius: screenSize.width * 0.15,
      child: new Icon(Icons.check,
          color: Colors.white, size: screenSize.width * 0.16),
    ));
  }

  void _onBackToLoginPressed() {
    var model = Provider.of<RegistrationModel>(context, listen: false);
    model.finish();
  }
}
