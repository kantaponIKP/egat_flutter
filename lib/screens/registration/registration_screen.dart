import 'package:egat_flutter/screens/registration/location/location_screen.dart';
import 'package:egat_flutter/screens/registration/meter/meter_screen.dart';
import 'package:egat_flutter/screens/registration/otp/otp_screen.dart';
import 'package:egat_flutter/screens/registration/state/registration_status.dart';
import 'package:egat_flutter/screens/registration/success/success_screen.dart';
import 'package:egat_flutter/screens/registration/user_info/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return 
    // Scaffold(
    //     backgroundColor: Theme.of(context).backgroundColor,
    //     body: 
        _buildBody(context);
        // );
  }

  Widget _buildBody(BuildContext context) {
    RegistrationStatus registration = Provider.of<RegistrationStatus>(context);

    Widget screen = Container();
    Duration duration = Duration.zero;

    if (registration.state == RegistrationState.UserInfo) {
      screen = UserInfoScreen(key: Key('user_info_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.Meter) {
      screen = MeterScreen(key: Key('meter_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.Location) {
      screen = LocationScreen(key: Key('location_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.Otp) {
      screen = OtpScreen(key: Key('otp_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.Success) {
      screen = SuccessScreen(key: Key('success_screen'));
      duration = Duration(milliseconds: 200);
    }

    return AnimatedSwitcher(
      duration: duration,
      child: screen,
      transitionBuilder: buildSlideTransition,
    );
  }

  Widget buildSlideTransition(Widget child, Animation<double> animation) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();

    _initStateListener();
  }

  void _initStateListener() {
    RegistrationStatus registration =
        Provider.of<RegistrationStatus>(context, listen: false);

    registration.addListener(_whenStateChanged);
  }

  void _whenStateChanged() {
    RegistrationStatus registration =
        Provider.of<RegistrationStatus>(context, listen: false);
    if (registration.state == RegistrationState.Dismiss) {
      Navigator.of(context).pop();
    }
  }
}
