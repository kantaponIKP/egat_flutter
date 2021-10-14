import 'package:egat_flutter/screens/registration/api/registration_api.dart';
import 'package:egat_flutter/screens/registration/api/registration_api_mock.dart';
import 'package:egat_flutter/screens/registration/state/location.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:egat_flutter/screens/registration/state/otp.dart';
import 'package:egat_flutter/screens/registration/state/registration_session.dart';
import 'package:egat_flutter/screens/registration/state/registration_status.dart';
import 'package:egat_flutter/screens/registration/state/user_info.dart';
import 'package:flutter/widgets.dart';

class RegistrationModel extends ChangeNotifier {
  late final RegistrationStatus status;
  late final UserInfo userInfo;
  late final RegistrationSession session;
  late final Meter meter;
  late final Location location;
  late final Otp otp;
  // late final Password password;

  RegistrationModel() {
    status = RegistrationStatus(this);
    userInfo = UserInfo(this);
    session = RegistrationSession(this);
    meter = Meter(this);
    location = Location(this);
    otp = Otp(this);
    // password = Password(this);
  }

  // TODO : API
  // RegistrationApi api = RegistrationApi();
  RegistrationApiMock api = RegistrationApiMock();


  Future<void> cancelRegistration() async {
    status.setStateDismiss();
  }

  void requestFaceNextState() {
    status.setStatePassword();
  }

  void whenRegistrationStatusChanged() {}

  void finish() {
    if (status.state == RegistrationState.Success) {
      status.setStateDismiss();
    }
  }
}
