import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({Key? key}) : super(key: key);

  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  // List<bool> isSelected = [false, true];

  List<bool> _isSelected = [false, true];

  void setInit() {
    setState(() {
      Locale _nowLocale = Localizations.localeOf(context);

      if (_nowLocale.toString() == 'th') {
        _isSelected = [true, false];
      } else {
        _isSelected = [false, true];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setInit();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              _changeLanguage(context);
            },
            child: Icon(Icons.language)),
        ToggleButtons(
          renderBorder: false,
          children: <Widget>[
            Text('TH'),
            Text('EN'),
            // Text('TH', style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
          onPressed: (int index) {
            _changeLanguage(context);
          },
          isSelected: _isSelected,
        ),
      ],
    );
  }

  Future<void> _changeLanguage(context) async {
    await showLoading();
    try {
      Locale _nowLocale = Localizations.localeOf(context);
      AppLocale locale = Provider.of<AppLocale>(context, listen: false);

      setState(() {
        _isSelected[0] = !_isSelected[0];
        _isSelected[1] = !_isSelected[1];

        if (_nowLocale.toString() == 'th') {
          locale.changeLanguage(Locale("en"), context);
        } else {
          locale.changeLanguage(Locale("th"), context);
        }
      });
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }
}
