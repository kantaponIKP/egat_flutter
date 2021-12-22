import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';

void showException(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: failedColor,
    ),
  );
}

void showIntlException(BuildContext context, Object exception) {
  if (exception is IntlException) {
    showException(
      context,
      exception.getIntlMessage(
        AppLocalizations.of(context),
      ),
    );
  } else {
    showException(context, exception.toString());
  }
}
