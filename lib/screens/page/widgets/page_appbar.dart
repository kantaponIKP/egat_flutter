import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageAppbar extends StatelessWidget with PreferredSizeWidget {
  final String firstTitle;
  final String secondTitle;

  PageAppbar({
    Key? key,
    required this.firstTitle,
    required this.secondTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 24),
          children: <TextSpan>[
            TextSpan(
                text: firstTitle,
                style: TextStyle(color: Theme.of(context).primaryColor)),
            TextSpan(
              text: ' $secondTitle',
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
