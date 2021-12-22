import 'package:egat_flutter/i18n/app_localizations.dart';

class IntlException implements Exception {
  final String message;
  final String intlMessage;
  const IntlException({
    required this.message,
    required this.intlMessage,
  });

  getIntlMessage(AppLocalizations appLocal){
    return appLocal.translate(intlMessage);
  }
}
