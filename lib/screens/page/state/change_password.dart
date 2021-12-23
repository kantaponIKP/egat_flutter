import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePasswordRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ChangePasswordModel {
  final bool? isErrorPasswordIncorrect;

  ChangePasswordModel({
    this.isErrorPasswordIncorrect,
  });
}

class ChangePassword extends ChangeNotifier {
  ChangePasswordModel _info =
      ChangePasswordModel(isErrorPasswordIncorrect: false);

  final accessToken =
      "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJBLWVFWExEU21pbFNwNU5ESjVyWmxnLS1FWDdRcEF4QVdRc3lsMHVPQU4wIn0.eyJleHAiOjE2MzU5NDUzMDAsImlhdCI6MTYzNTkyNzMwMCwianRpIjoiZDQ0MmJlNWMtNWMwYy00ODYxLTkzNjktMTNlMDQ1MDljZWNlIiwiaXNzIjoiaHR0cHM6Ly9rZXljbG9hay5pa25vd3BsdXMuY28udGgvYXV0aC9yZWFsbXMvZWdhdCIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI0MTU0NmRmMy0yZWFjLTQ4ZDgtOTViYS1kNmM0NDQwZDJmNGYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJlZ2F0LXAycC10cmFkaW5nIiwic2Vzc2lvbl9zdGF0ZSI6ImFkODQwY2ViLTQ2NDMtNDRkMi1hNjg3LTRkMGM4MTk0NjQxNCIsImFjciI6IjEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cHM6Ly9lZ2F0LXAycC1sb2dpbi5kaS5pa25vd3BsdXMuY28udGgvIiwiaHR0cHM6Ly9lZ2F0LXAycC1yZWdpc3Rlci5kaS5pa25vd3BsdXMuY28udGgiLCJodHRwOi8vbG9jYWxob3N0OjMwMDAvKiIsImh0dHA6Ly9sb2NhbGhvc3Q6MzAwMCJdLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1lZ2F0Iiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsImNvbnN1bWVyIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiZWdhdC1wMnAtdHJhZGluZyI6eyJyb2xlcyI6WyJjb25zdW1lciJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJlbWFpbCBwcm9maWxlIiwic2lkIjoiYWQ4NDBjZWItNDY0My00NGQyLWE2ODctNGQwYzgxOTQ2NDE0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJwaGFzYXd1dC5zQGdtYWlsLmNvbSIsImVtYWlsIjoicGhhc2F3dXQuc0BnbWFpbC5jbzEifQ.AQ4paHW8xrwbivsnBp5Rz41j4I6wM3Xtzq6o1_mxMVn29HOsKAzhqW9TCIjR8NtZlljRO8CaqdnwPLS7muriEfBp7PFqV9XteKHiydB9qx1WG3lG0muWRLoffdkIy1xKAcuvOmfF_I7hqoAtwLXYG3rf6hq9FiZPOUy_RUNC4uGvmxq1zrn1fjNFL-YwSuvN_pkZ4ptZGq2LGMjZ6cztUiaoZhgWAS9vREbfHf5V6cWmj7PMUokcRJvV1xoW12MxRpl5FKrvv5bgNZ244G2r6i678Uv-SPrlI5WSke6HLlvTsgm01bD1J5ZdokJlmsYHBLgUx_3WGwn0HGsYFd3wFA";
  final userId = "";
  final PageModel parent;

  ChangePassword(this.parent);

  setInfo(ChangePasswordModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    bool? isErrorPasswordIncorrect,
  }) {
    if (isErrorPasswordIncorrect == null) {
      isErrorPasswordIncorrect = info.isErrorPasswordIncorrect;
    }

    var newInfo = ChangePasswordModel(
      isErrorPasswordIncorrect: isErrorPasswordIncorrect,
    );

    setInfo(newInfo);
  }

  ChangePasswordModel get info => _info;

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    Response response;
    // try {
      response = await parent.api.changePassword(
        ChangePasswordRequest(
            oldPassword: oldPassword, newPassword: newPassword),
        AccessRequest(
          accessToken: accessToken,
          userId: userId,
        ),
      );
      if (response.statusCode == 404) { //TODO
       print("404!");
        updateInfo(isErrorPasswordIncorrect: true);
        return false;
      }
      else if(response.statusCode == 409){
        print("409!");
        throw "Your new password cannot be the same as your current password";
      }else if(response.statusCode == 204){
        return true;
      }else{
        throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
      }
    // return false;
  }

    void goToHomePage() {


    parent.status.setStateHome();
  }
}
