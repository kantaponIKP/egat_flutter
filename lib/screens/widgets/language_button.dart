import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({Key? key}) : super(key: key);

  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    Locale _nowLocale = Localizations.localeOf(context);
    logger.d('hello ${_nowLocale.toString()}' );
    AppLocale locale = Provider.of<AppLocale>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(Icons.language),
        ToggleButtons(
          renderBorder: false,
          children: <Widget>[
            Text('TH'),
            Text('EN'),
            // Text('TH', style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
          onPressed: (int index) {
            // appLanguage.changeLanguage(Locale("en"));
            if(_nowLocale.toString() == 'th'){
            locale.changeLanguage(Locale("en"));
            }else {
              locale.changeLanguage(Locale("th"));
            }
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < isSelected.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            });
          },
          isSelected: isSelected,
        ),
      ],
    );
  }
}
