import 'package:egat_flutter/screens/registration/consent/consent_screen.dart';
import 'package:egat_flutter/screens/registration/location/location_screen.dart';
import 'package:egat_flutter/screens/registration/meter/meter_screen.dart';
import 'package:egat_flutter/screens/registration/otp/otp_mobilenumber_screen.dart';
import 'package:egat_flutter/screens/registration/otp/otp_pin_screen.dart';
import 'package:egat_flutter/screens/registration/state/registration_status.dart';
import 'package:egat_flutter/screens/registration/success/success_screen.dart';
import 'package:egat_flutter/screens/registration/user_info/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void askForRegistrationCancelConfirmation(BuildContext context) {
  // var model = Provider.of<RegistrationModel>(context, listen: false);

  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return Provider(
  //       create: (context) => model,
  //       child: RegistrationCancellationConfirmDialog(),
  //     );
  //   },
  // );
}

Future<void> showLoading() async {
  if (EasyLoading.isShow) {
    return;
  }

  await EasyLoading.show(
    status: "กรุณารอสักครู่...",
    maskType: EasyLoadingMaskType.black,
  );
}

Future<void> hideLoading() async {
  await EasyLoading.dismiss();
}

void showException(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class RegistrationCancellationConfirmDialog extends StatelessWidget {
  RegistrationCancellationConfirmDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RegistrationModel model = Provider.of<RegistrationModel>(context);

    return AlertDialog(
      title: const Text("ยกเลิกการลงทะเบียน"),
      content: const Text(
        "ต้องการที่จะยกเลิกการลงทะเบียนหรือไม่?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "ไม่ต้องการ",
            // style: TextStyle(
            //   color: neutralColor,
            // ),
          ),
        ),
        TextButton(
          onPressed: () async {
            // await model.cancelRegistration();
            Navigator.pop(context);
          },
          child: const Text(
            "ต้องการ",
            style: TextStyle(
              // color: dangerColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isIdCardIntroductionIntroduced = false;
  bool _isIdCardIntroductionNeedSlideTransition = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).backgroundColor,body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    RegistrationStatus registration = Provider.of<RegistrationStatus>(context);

    Widget screen = Container();
    Duration duration = Duration.zero;

    if (registration.state == RegistrationState.UserInfo) {
      screen = UserInfoScreen(key: Key('information_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.Consent) {
      screen = ConsentScreen(key: Key('consent_screen'));
      duration = Duration(milliseconds: 150);
    }

    if (registration.state == RegistrationState.Meter) {
      screen =
          MeterScreen(key: Key('meter_screen'));

      if (_isIdCardIntroductionNeedSlideTransition) {
        duration = Duration(milliseconds: 300);
      } else {
        duration = Duration(milliseconds: 100);
      }
    }



    if (registration.state == RegistrationState.Location) {
      screen = LocationScreen(key: Key('location_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.OtpMobileNumber) {
      screen = OtpMobileNumberScreen(key: Key('otp_mobilenumber'));
      duration = Duration(milliseconds: 200);
    }

    if (registration.state == RegistrationState.OtpPin) {
      screen = OtpPinScreen(key: Key('otp_pin'));
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

    if (registration.state == RegistrationState.Meter) {
      if (!_isIdCardIntroductionIntroduced) {
        _isIdCardIntroductionIntroduced = true;
        _isIdCardIntroductionNeedSlideTransition = true;
      } else if (_isIdCardIntroductionIntroduced) {
        if (_isIdCardIntroductionNeedSlideTransition) {
          _isIdCardIntroductionNeedSlideTransition = false;
        }
      }
    }

    if (registration.state == RegistrationState.Dismiss) {
      Navigator.of(context).pop();
    }
  }
}
