import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class DataModel {
  final String? energyStorage;
  final String? pv;
  final String? grid;

  DataModel({
    this.energyStorage,
    this.pv,
    this.grid,
  });
}

class Data extends ChangeNotifier {
  DataModel _info = DataModel();

  final PageModel parent;

  Data(this.parent);

  DataModel get info => _info;

  setInfo(DataModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    String? fullName,
    String? phoneNumber,
    String? email,
  }) {
    if (fullName == null) {
      fullName = info.energyStorage;
    }

    if (email == null) {
      phoneNumber = info.pv;
    }

    if (email == null) {
      email = info.grid;
    }

    var newInfo = DataModel(
      energyStorage: fullName,
      pv: phoneNumber,
      grid: email,
    );

    setInfo(newInfo);
  }

  setNoInfo() {
    this._info = DataModel();
    notifyListeners();
  }


  setPageChangePassword() {
    // parent.status.setStateChangePassword();
    parent.status.setStateContactUs();
  }

  //TODO
  Future<void> submitPersonalInfo({fullName, phoneNumber, email}) async {
  //   var response = await parent.session
  //       .requestNewRegistrationSession(email: email, phoneNumber: phoneNumber,password: password);
  //   if (parent.session.info == null) {
  //     throw "Unable to submit new registration session.";
  //   }
  //   parent.status.setStateMeter();
  }
}
