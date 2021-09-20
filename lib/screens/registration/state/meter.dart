import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

class Meter extends ChangeNotifier {
  final RegistrationModel parent;

  Meter(this.parent);

  nextPage() {
    parent.status.setStateLocation();
  }

  backPage() {
    parent.status.setStateUserInfo();
  }
}
