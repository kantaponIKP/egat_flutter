import 'package:egat_flutter/screens/registration/api/model/GetSessionStatusRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationStatusState.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

class RegistrationSessionInfo {
  final String sessionId;
  final String sessionToken;

  final String mobileNumber;

  final RestRegistrationStatus status;

  const RegistrationSessionInfo({
    required this.sessionId,
    required this.sessionToken,
    required this.status,
    required this.mobileNumber,
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

  Future<void> requestNewRegistrationSession() async {
    var response = await parent.api.createRegistrationSession(
      RegistrationRequest(
        clientInfo: "n/a",
        address: parent.userInfo.info.address ?? "",
        email: parent.userInfo.info.email ?? "",
        mobileNo: parent.userInfo.info.mobileNo ?? "",
      ),
    );

    setSession(
      RegistrationSessionInfo(
        sessionId: response.sessionId ?? "",
        sessionToken: response.sessionToken ?? "",
        status: response.status ?? RestRegistrationStatus.RequireCardInfo,
        mobileNumber: parent.userInfo.info.mobileNo ?? "",
      ),
    );
  }

  Future<void> reloadRegistrationSession() async {
    var response = await parent.api.getRegistrationSession(
      GetSessionStatusRequest(
        registrationId: parent.session.info!.sessionId,
        registrationToken: parent.session.info!.sessionToken,
      ),
    );

    setSession(
      RegistrationSessionInfo(
        sessionId: response.sessionId ?? "",
        sessionToken: response.sessionToken ?? "",
        status: response.status ?? RestRegistrationStatus.RequireCardInfo,
        mobileNumber: response.mobileNo ?? "",
      ),
    );
  }

  _setSession(RegistrationSessionInfo? session) {
    info = session;

    notifyListeners();
  }
}
