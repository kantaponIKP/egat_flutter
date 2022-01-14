import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/models/AccessRequest.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/models/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/models/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/personal_info_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class PersonalInfoModel {
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? photo;

  PersonalInfoModel({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.photo,
  });
}

class PersonalInfoState extends ChangeNotifier {
  LoginSession? _loginSession;
  PersonalInfoModel _info = PersonalInfoModel();

  LoginSession? get loginSession => _loginSession;

  void setLoginSession(LoginSession state) {
    if (_loginSession == state) {
      return;
    }

    _loginSession = state;
    notifyListeners();
  }

  PersonalInfoState();

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
      fullName = info.fullName;
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
      fullName: fullName,
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
      {String? fullName,
      String? phoneNumber,
      String? email,
      String? photo}) async {
    final accessToken = loginSession!.info!.accessToken;
    final userId = loginSession!.info!.userId;

    if (accessToken == "") {
      throw IntlException(
        message: "Invalid session",
        intlMessage: "error-invalidSession",
      );
    }

    ChangePersonalInfoRequest changePersonalInfo =
        new ChangePersonalInfoRequest();

    if (info.fullName != fullName) {
      changePersonalInfo.setFullName(fullName!);
    }
    if (info.phoneNumber != phoneNumber) {
      changePersonalInfo.setPhoneNumber(phoneNumber!);
    }
    if (info.email != email) {
      changePersonalInfo.setEmail(email!);
    }
    var response = await personalInfoApi.changePersonalInfo(
      changePersonalInfo,
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );

    getPersonalInformation();
  }

  Future<void> changePhoto(String photo) async {
    final accessToken = loginSession!.info!.accessToken;
    final userId = loginSession!.info!.userId;

    if (accessToken == "") {
      throw IntlException(
        message: "Invalid session",
        intlMessage: "error-invalidSession",
      );
    }

    var response = await personalInfoApi.changePhoto(
      ChangePhotoRequest(photo: photo),
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
  }

  Future<void> removePhoto() async {
    final accessToken = loginSession!.info!.accessToken;
    final userId = loginSession!.info!.userId;

    if (accessToken == "") {
      throw IntlException(
        message: "Invalid session",
        intlMessage: "error-invalidSession",
      );
    }

    var response = await personalInfoApi.removePhoto(
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
  }

  Future<void> getPersonalInformation() async {
    final accessToken = loginSession!.info!.accessToken;
    final userId = loginSession!.info!.userId;

    if (accessToken == "") {
      throw IntlException(
        message: "Invalid session",
        intlMessage: "error-invalidSession",
      );
    }

    var response = await personalInfoApi.getPersonalInfo(
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );

    updateInfo(
        fullName: response.fullName,
        phoneNumber: response.phoneNumber,
        email: response.email,
        photo: response.photo);
  }

  void setPageChangePassword() {
    // parent.status.setStateChangePassword();
    //TODO:
  }

  //TODO
  Future<void> submitPersonalInfo({fullName, phoneNumber, email}) async {}
}
