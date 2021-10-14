import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordSessionInfo {
  final String sessionId;
  final String sessionToken;

  const ForgotPasswordSessionInfo({
    required this.sessionId,
    required this.sessionToken,
  });
}

class ForgotPasswordSession extends ChangeNotifier {
  ForgotPasswordSessionInfo? info;
  ForgotPasswordModel parent;

  ForgotPasswordSession(this.parent);

  setSession(ForgotPasswordSessionInfo session) {
    _setSession(session);
  }

  setNoSession() {
    _setSession(null);
  }

  Future<OtpForgotPasswordResponse> requestNewForgotPasswordSession({required String email}) async {
    var response = await parent.api.sendOtp(
      OtpForgotPasswordRequest(
        email: email,
      ),
    );

    setSession(
      ForgotPasswordSessionInfo(
        sessionId: response.sessionId ?? "",
        sessionToken: response.sessionToken ?? "",
      ),
    );

    return response;
  }

  _setSession(ForgotPasswordSessionInfo? session) {
    info = session;

    notifyListeners();
  }
}
