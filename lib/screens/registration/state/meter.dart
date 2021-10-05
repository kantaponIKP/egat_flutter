import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/Role.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

enum MeterStatus {
  Uncheck,
  Checked,
}

class MeterModel {
  final String? meterName;
  final String? meterId;
  final String? location;
  final int? roleIndex;
  final Role? role;
  final String? latitude;
  final String? longtitude;
  final MeterStatus? status;
  final String? errorText;

  MeterModel({
    this.meterName,
    this.meterId,
    this.location,
    this.roleIndex,
    this.role,
    this.latitude,
    this.longtitude,
    this.status,
    this.errorText,
  });
}

class Meter extends ChangeNotifier {
  // MeterModel _info = MeterModel(status: MeterStatus.Uncheck);
  MeterModel _info = MeterModel(status: MeterStatus.Uncheck, errorText: null, location: '');
  // status: MeterStatus.Uncheck

  final RegistrationModel parent;
  String? meterName;
  String? meterID;
  String? location;
  int? roleIndex;
  Role? role;
  String? latitude;
  String? longtitude;
  MeterStatus? status;
  String? errorText;

  // initializer(){
  //   updateInfo(status: MeterStatus.Uncheck);
  //   // _info.status = MeterStatus.Uncheck;
  //   //  = Role.Prosumer;
  // }
  MeterModel get info => _info;

  Meter(this.parent);

  void setInfo(MeterModel info) {
    this._info = info;
    notifyListeners();
  }

  void updateInfo({
    String? meterName,
    String? meterID,
    String? location,
    int? roleIndex,
    String? latitude,
    String? longtitude,
    MeterStatus? status,
    String? errorText,
  }) {
    if (meterName == null) {
      meterName = info.meterName;
    }

    if (meterID == null) {
      meterID = info.meterId;
    }

    if (location == null) {
      location = info.location;
    }

    if (roleIndex == null) {
      roleIndex = info.roleIndex;
      role = info.role;
    } else {
      role = getRoleFromIndex(roleIndex);
    }

    if (latitude == null) {
      latitude = info.latitude;
    }

    if (longtitude == null) {
      longtitude = info.longtitude;
    }

    if (status == null) {
      status = info.status;
    }

    if (status == null) {
    errorText = info.errorText;
    }

    var newInfo = MeterModel(
      meterName: meterName,
      meterId: meterID,
      location: location,
      roleIndex: roleIndex,
      role: role,
      status: status,
      errorText: errorText,
    );

    setInfo(newInfo);
  }

  void setRole(Role role) {
    this.role = role;
  }

  // setCheckedStatus() {
  //   this.info.status = MeterStatus.Checked;
  // }

  // setUncheckStatus() {
  //   this.status = MeterStatus.Uncheck;
  // }

  Role getRoleFromIndex(int roleIndex) {
    switch (roleIndex) {
      case 0:
        return Role.Prosumer;
      case 1:
        return Role.Aggregator;
      case 2:
        return Role.Consumer;
      default:
        throw new ArgumentError("Unknown role index");
    }
  }

  void nextPage() {
    parent.status.setStateLocation();
  }

  void backPage() {
    parent.status.setStateUserInfo();
  }

  Future<void> getLocation({String? meterId}) async {
    logger.d(meterId);
    if(meterId == '' || meterId == null){
      updateInfo(errorText: 'Require');
      return;
    }else{
      updateInfo(errorText: null);
    }

    var response = await parent.api.getLocation(
      LocationRequest(
        meterId: meterId,
        sessionId: parent.session.info!.sessionId,
      ),
    );
    // TODO
    // Success
    if(true){
      updateInfo(location: response.location, status: MeterStatus.Checked);
    }
    else{
      updateInfo(errorText: 'Already used');
    }

  }
}
