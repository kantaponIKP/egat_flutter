import 'package:flutter/cupertino.dart';

class MainScreenTitleState extends ChangeNotifier {
  List<String> _titles = const [];
  List<String> get titles => _titles;

  MainScreenTitleType _type = MainScreenTitleType.LOGO;
  MainScreenTitleType get type => _type;

  void setTitleLogo() {
    _type = MainScreenTitleType.LOGO;

    Future<void>.delayed(const Duration(milliseconds: 0), () {
      notifyListeners();
    });
  }

  void setTitleOneTitle({
    required String title,
  }) {
    _type = MainScreenTitleType.ONE_TITLE;
    _titles = [title];

    Future<void>.delayed(const Duration(milliseconds: 0), () {
      notifyListeners();
    });
  }

  void setTitleTwoTitles({
    required String title,
    required String secondaryTitle,
  }) {
    _type = MainScreenTitleType.TWO_TITLE;
    _titles = [title, secondaryTitle];

    Future<void>.delayed(const Duration(milliseconds: 0), () {
      notifyListeners();
    });
  }
}

enum MainScreenTitleType {
  LOGO,
  ONE_TITLE,
  TWO_TITLE,
}
