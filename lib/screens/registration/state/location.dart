import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

class Location extends ChangeNotifier {
  final RegistrationModel parent;
  
  Location(this.parent);

  nextPage() {
    parent.status.setStateOtp();
  }

  backPage() {
    parent.status.setStateMeter();
  }
}
