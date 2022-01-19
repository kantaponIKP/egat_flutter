import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class PersonalInfoModel {
  final String? username;
  final String? phoneNumber;
  final String? email;
  final String? photo;

  PersonalInfoModel({
    this.username,
    this.phoneNumber,
    this.email,
    this.photo,
  });
}

class PersonalInfo extends ChangeNotifier {
  PersonalInfoModel _info = PersonalInfoModel();

  final userId = "";
  //TODO:

  final PageModel parent;

  PersonalInfo(this.parent);

  PersonalInfoModel get info => _info;

  setInfo(PersonalInfoModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? photo,
  }) {
    if (fullName == null) {
      fullName = info.username;
    }

    if (phoneNumber == null) {
      phoneNumber = info.phoneNumber;
    }

    if (email == null) {
      email = info.email;
    }

    if (photo == null) {
      photo = info.photo;
    }

    var newInfo = PersonalInfoModel(
      username: fullName,
      phoneNumber: phoneNumber,
      email: email,
      photo: photo,
    );

    setInfo(newInfo);
  }

  setNoInfo() {
    this._info = PersonalInfoModel();
    notifyListeners();
  }

  Future<void> changePersonalInformation(
      {String? username,
      String? phoneNumber,
      String? email,
      String? photo}) async {
    final accessToken = parent.session.info!.accessToken;
    ChangePersonalInfoRequest changePersonalInfo =
        new ChangePersonalInfoRequest();

    if (info.username != username) {
      changePersonalInfo.setUsername(username!);
    }
    if (info.phoneNumber != phoneNumber) {
      changePersonalInfo.setPhoneNumber(phoneNumber!);
    }
    if (info.email != email) {
      changePersonalInfo.setEmail(email!);
    }
    var response = await parent.api.changePersonalInfo(
      changePersonalInfo,
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );

    getPersonalInformation();
  }

  Future<void> changePhoto(String photo) async {
    final accessToken = parent.session.info!.accessToken;
    var response = await parent.api.changePhoto(
      ChangePhotoRequest(photo: photo),
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
  }

  Future<void> removePhoto() async {
    final accessToken = parent.session.info!.accessToken;
    var response = await parent.api.removePhoto(
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
  }

  Future<void> getPersonalInformation() async {
    final accessToken = parent.session.info!.accessToken;
    var response = await parent.api.getPersonalInfo(
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
    updateInfo(
      fullName: response.username,
      phoneNumber: response.phoneNumber,
      email: response.email,
      photo: response.photo,
    );

    // TODO
    // Success

    // if(true){
    //   updateInfo(location: response.location, zoomLevel: response.zoomLevel!.toDouble(), status: MeterStatus.Checked, latitude: response.position!.lat!.toDouble(), longtitude: response.position!.lng!.toDouble());
    //   logger.d(info.zoomLevel);
    // }

    // else if(false){
    //   updateInfo(errorText: 'Already used');
    // }else if(false){
    //   updateInfo(errorText: 'Invalid meter id');
    // }
  }

  void setPageChangePassword() {
    // parent.status.setStateChangePassword();
    parent.status.setStateChangePassword();
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
