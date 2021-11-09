import 'package:egat_flutter/screens/registration/registration_model.dart';
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
          return PageModel();
        }),
        ChangeNotifierProxyProvider<PageModel, UserInfo>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.userInfo;
          },
          update: (
            BuildContext context,
            PageModel model,
            UserInfo? previous,
          ) {
            return model.userInfo;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Meter>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.meter;
          },
          update: (
            BuildContext context,
            PageModel model,
            Meter? previous,
          ) {
            return model.meter;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Location>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.location;
          },
          update: (
            BuildContext context,
            PageModel model,
            Location? previous,
          ) {
            return model.location;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, RegistrationSession>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.session;
          },
          update: (
            BuildContext context,
            PageModel model,
            RegistrationSession? previous,
          ) {
            return model.session;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, RegistrationStatus>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.status;
          },
          update: (
            BuildContext context,
            PageModel model,
            RegistrationStatus? previous,
          ) {
            return model.status;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Otp>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.otp;
          },
          update: (
            BuildContext context,
            PageModel model,
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
