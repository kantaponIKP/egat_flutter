import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class SidebarModel {
  String? fullName;
  String? email;
  String? photo;
  int? index;

  SidebarModel({
    this.fullName,
    this.email,
    this.photo,
    this.index,
  });
}

class Sidebar extends ChangeNotifier {
  LoginSession? _loginSession;
  final PageModel parent;
  SidebarModel _info = SidebarModel();

  LoginSession? get loginSession => _loginSession;
  Sidebar(this.parent);

  SidebarModel get info => _info;

  setInfo(SidebarModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    String? fullName,
    String? email,
    String? photo,
    int? index,
  }) {
    if (fullName == null) {
      fullName = info.fullName;
    }

    if (email == null) {
      email = info.email;
    }

    if (photo == null) {
      photo = info.photo;
    }

    if (index == null) {
      index = info.index;
    }

    var newInfo = SidebarModel(
      fullName: fullName,
      email: email,
      photo: photo,
      index: index,
    );

    setInfo(newInfo);
  }

  setPageHome() {
    parent.status.setStateHome();
  }

  setPagePersonalInfo() {
    parent.status.setStatePersonalInfo();
  }

  setPageChangePassword() {
    parent.status.setStateChangePassword();
  }

  setPageContactUs() {
    parent.status.setStateContactUs();
  }

  setPageNews() {
    parent.status.setStateNews();
  }

  setPageSetting() {
    parent.status.setStateSetting();
  }

  setPageLogin() {
    //TODO:
    parent.status.setStateSetting();
  }

  setPageSignout() {
    //TODO:
    parent.status.setStateSigout();
  }

  setPersonalInfo() async {}
}
