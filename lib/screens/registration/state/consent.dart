import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

enum ConsentState { Unknown, Rejected, Accepted }

class Consent extends ChangeNotifier {
  ConsentState state = ConsentState.Unknown;

  final RegistrationModel parent;

  Consent(this.parent);

  Future<void> _setConsent(ConsentState state) async {
    this.state = state;
    await parent.whenConsentChanged();
    notifyListeners();
  }

  Future<void> acceptConsent() async {
    await _setConsent(ConsentState.Accepted);

    parent.status.setStateUserInfo();
  }

  Future<void> rejectConsent() async {
    await _setConsent(ConsentState.Rejected);
    parent.status.setStateDismiss();
  }

  Future<void> resetConsent() async {
    await _setConsent(ConsentState.Unknown);
    parent.status.setStateConsent();
  }
}
