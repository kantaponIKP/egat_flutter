import 'package:egat_flutter/screens/registration/api/model/GetSessionStatusRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationSessionRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationStatus.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

class RegistrationSessionInfo {
  final String sessionId;

  // final RestRegistrationStatus status;

  const RegistrationSessionInfo({
    required this.sessionId,
  });
}

class RegistrationSession extends ChangeNotifier {
  RegistrationSessionInfo? info;
  RegistrationModel parent;

  RegistrationSession(this.parent);

  setSession(RegistrationSessionInfo session) {
    _setSession(session);
  }

  setNoSession() {
    _setSession(null);
  }

  Future<void> requestNewRegistrationSession({required String email, required String phoneNumber}) async {
    var response = await parent.api.createRegistrationSession(
      RegistrationSessionRequest(
        email: email,
        phoneNumber: phoneNumber,
      ),
    );

    setSession(
      RegistrationSessionInfo(
        sessionId: response.sessionId ?? "",
      ),
    );
  }

  // Future<void> reloadRegistrationSession() async {
  //   var response = await parent.api.getRegistrationSession(
  //     GetSessionStatusRequest(
  //       email: parent.session.info!.email,
  //       phoneNumber: parent.session.info!.sessionToken,
  //     ),
  //   );

  //   setSession(
  //     RegistrationSessionInfo(
  //       sessionId: response.sessionId ?? "",
  //       sessionToken: response.sessionToken ?? "",
  //       status: response.status ?? RestRegistrationStatus.RequireCardInfo,
  //       mobileNumber: response.mobileNo ?? "",
  //     ),
  //   );
  // }

  _setSession(RegistrationSessionInfo? session) {
    info = session;

    notifyListeners();
  }
}
