import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:egat_flutter/screens/registration/state/meter.dart';
import 'package:flutter/cupertino.dart';

class UserInfoModel {
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? password;

  UserInfoModel({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.password,
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
    String? fullName,
    String? phoneNumber,
    String? email,
    String? password,
  }) {
    if (fullName == null) {
      fullName = info.fullName;
    }

    if (email == null) {
      phoneNumber = info.phoneNumber;
    }

    if (email == null) {
      email = info.email;
    }

    if (password == null) {
      password = info.password;
    }

    var newInfo = UserInfoModel(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );

    setInfo(newInfo);
  }

  setNoInfo() {
    this._info = UserInfoModel();
    notifyListeners();
  }

  nextPage() {
    // parent.meter.updateInfo(status: MeterStatus.Uncheck);
    // parent.meter.setInfo(MeterModel(
    //     meterName: "",
    //     meterId: "",
    //     location: "",
    //     roleIndex: 0,
    //     latitude: "",
    //     longtitude: "",
    //     status: MeterStatus.Uncheck));

    parent.status.setStateMeter();
  }

  //TODO
  Future<void> submitUserInfo({fullName, phoneNumber, email, password}) async {
    // setInfo(UserInfoModel(fullName: fullName, phoneNumber: phoneNumber, email: email, password: password));
    var response = await parent.session
        .requestNewRegistrationSession(email: email, phoneNumber: phoneNumber,password: password);
    if (parent.session.info == null) {
      throw "Unable to submit new registration session.";
    }
    // parent.meter.setInfo(MeterModel(
    //     meterName: "",
    //     meterId: "",
    //     location: "",
    //     roleIndex: 0,
    //     latitude: "",
    //     longtitude: "",
    //     status: MeterStatus.Uncheck));

    // if (identical(response.status, RestLoginStatus.Success)) {
    //   // TODO
    // } else if (identical(response.status, RestLoginStatus.RequireEmail)) {
    //   setIsError(true);
    // } else if (identical(response.status, RestLoginStatus.RequirePassword)) {
    //   setIsError(true);
    // }

    parent.status.setStateMeter();
  }
}
