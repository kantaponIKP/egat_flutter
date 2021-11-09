import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class Sidebar extends ChangeNotifier {
  final PageModel parent;

  Sidebar(this.parent);

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

  setPageLogin() { //TODO:
    parent.status.setStateSetting();
  }
}
