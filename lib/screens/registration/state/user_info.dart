import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

class UserInfoModel {
  final String? address;
  final String? email;
  final String? mobileNo;

  UserInfoModel({
    this.address,
    this.email,
    this.mobileNo,
  });
}

class UserInfo extends ChangeNotifier {
  UserInfoModel _info = UserInfoModel();

  RegistrationModel parent;

  UserInfo(this.parent);

  UserInfoModel get info => _info;

  setInfo(UserInfoModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    String? address,
    String? email,
    String? mobileNo,
  }) {
    if (address == null) {
      address = info.address;
    }

    if (email == null) {
      email = info.email;
    }

    if (mobileNo == null) {
      mobileNo = info.mobileNo;
    }

    var newInfo = UserInfoModel(
      address: address,
      email: email,
      mobileNo: mobileNo,
    );

    setInfo(newInfo);
  }

  setNoInfo() {
    this._info = UserInfoModel();
    notifyListeners();
  }

  nextPage() {
    parent.status.setStateMeter();
  }

  //TODO
  // Future<void> submitUserInfo() async {
  //   await parent.session.requestNewRegistrationSession();

  //   if (parent.session.info == null) {
  //     throw "Unable to submit new registration.";
  //   }

  //   parent.status.setStateIdCardIntroduction();
  // }
}
