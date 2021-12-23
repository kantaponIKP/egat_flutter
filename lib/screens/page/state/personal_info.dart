import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
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

class PersonalInfo extends ChangeNotifier {
  PersonalInfoModel _info = PersonalInfoModel();

  final accessToken =
      "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJBLWVFWExEU21pbFNwNU5ESjVyWmxnLS1FWDdRcEF4QVdRc3lsMHVPQU4wIn0.eyJleHAiOjE2MzU5NDUzMDAsImlhdCI6MTYzNTkyNzMwMCwianRpIjoiZDQ0MmJlNWMtNWMwYy00ODYxLTkzNjktMTNlMDQ1MDljZWNlIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5pa25vd3BsdXMuY28udGgvYXV0aC9yZWFsbXMvZWdhdCIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI0MTU0NmRmMy0yZWFjLTQ4ZDgtOTViYS1kNmM0NDQwZDJmNGYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJlZ2F0LXAycC10cmFkaW5nIiwic2Vzc2lvbl9zdGF0ZSI6ImFkODQwY2ViLTQ2NDMtNDRkMi1hNjg3LTRkMGM4MTk0NjQxNCIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cHM6Ly9lZ2F0LXAycC1sb2dpbi5kaS5pa25vd3BsdXMuY28udGgvIiwiaHR0cHM6Ly9lZ2F0LXAycC1yZWdpc3Rlci5kaS5pa25vd3BsdXMuY28udGgiLCJodHRwOi8vbG9jYWxob3N0OjMwMDAvKiIsImh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1lZ2F0Iiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsImNvbnN1bWVyIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiZWdhdC1wMnAtdHJhZGluZyI6eyJyb2xlcyI6WyJjb25zdW1lciJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJlbWFpbCBwcm9maWxlIiwic2lkIjoiYWQ4NDBjZWItNDY0My00NGQyLWE2ODctNGQwYzgxOTQ2NDE0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJwaGFzYXd1dC5zQGdtYWlsLmNvbSIsImVtYWlsIjoicGhhc2F3dXQuc0BnbWFpbC5jbzEifQ.AQ4paHW8xrwbivsnBp5Rz41j4I6wM3Xtzq6o1_mxMVn29HOsKAzhqW9TCIjR8NtZlljRO8CaqdnwPLS7muriEfBp7PFqV9XteKHiydB9qx1WG3lG0muWRLoffdkIy1xKAcuvOmfF_I7hqoAtwLXYG3rf6hq9FiZPOUy_RUNC4uGvmxq1zrn1fjNFL-YwSuvN_pkZ4ptZGq2LGMjZ6cztUiaoZhgWAS9vREbfHf5V6cWmj7PMUokcRJvV1xoW12MxRpl5FKrvv5bgNZ244G2r6i678Uv-SPrlI5WSke6HLlvTsgm01bD1J5ZdokJlmsYHBLgUx_3WGwn0HGsYFd3wFA";
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
    print(fullName);
    print(phoneNumber);
    print(email);
    print(photo);
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
    print("photo");
    var response = await parent.api.changePhoto(
      ChangePhotoRequest(photo: photo),
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
  }

  Future<void> removePhoto() async {
    var response = await parent.api.removePhoto(
      AccessRequest(
        accessToken: accessToken,
        userId: userId,
      ),
    );
  }

  Future<void> getPersonalInformation() async {
    var response = await parent.api.getPersonalInfo(
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
