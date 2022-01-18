import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageAppbar extends StatelessWidget with PreferredSizeWidget {
  final String firstTitle;
  final String secondTitle;

  const PageAppbar({
    Key? key,
    required this.firstTitle,
    required this.secondTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context).getLocale().toString());
    return AppBar(
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          children: <TextSpan>[
            TextSpan(
                text: firstTitle,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            (AppLocalizations.of(context).getLocale().toString() == "th")
                ? TextSpan(text: '')
                : TextSpan(text: ' '),
            TextSpan(
              text: '$secondTitle',
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
