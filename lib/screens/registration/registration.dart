import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:egat_flutter/screens/registration/state/consent.dart';
import 'package:egat_flutter/screens/registration/state/location.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:egat_flutter/screens/registration/state/otp.dart';
import 'package:egat_flutter/screens/registration/state/registration_session.dart';
import 'package:egat_flutter/screens/registration/state/registration_status.dart';
import 'package:egat_flutter/screens/registration/state/user_info.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'registration_screen.dart';

class Registration extends StatefulWidget {
  final bool isResume;

  Registration({
    this.isResume = false,
    Key? key,
  }) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  _RegistrationState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return RegistrationModel();
        }),
        ChangeNotifierProxyProvider<RegistrationModel, Consent>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.consent;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            Consent? previous,
          ) {
            return model.consent;
          },
        ),
        ChangeNotifierProxyProvider<RegistrationModel, UserInfo>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.userInfo;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            UserInfo? previous,
          ) {
            return model.userInfo;
          },
        ),
        ChangeNotifierProxyProvider<RegistrationModel, Meter>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.meter;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            Meter? previous,
          ) {
            return model.meter;
          },
        ),
        ChangeNotifierProxyProvider<RegistrationModel, Location>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.location;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            Location? previous,
          ) {
            return model.location;
          },
        ),
        ChangeNotifierProxyProvider<RegistrationModel, RegistrationSession>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.session;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            RegistrationSession? previous,
          ) {
            return model.session;
          },
        ),
        ChangeNotifierProxyProvider<RegistrationModel, RegistrationStatus>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.status;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            RegistrationStatus? previous,
          ) {
            return model.status;
          },
        ),
        ChangeNotifierProxyProvider<RegistrationModel, Otp>(
          create: (context) {
            var model = Provider.of<RegistrationModel>(context, listen: false);
            return model.otp;
          },
          update: (
            BuildContext context,
            RegistrationModel model,
            Otp? previous,
          ) {
            return model.otp;
          },
        ),
      ],
      child: RegistrationScreen(),
    );
  }
}
