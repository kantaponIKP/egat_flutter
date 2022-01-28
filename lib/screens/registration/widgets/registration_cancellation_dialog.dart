import 'dart:io';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void askForRegistrationCancelConfirmation(BuildContext context) {
  var model = Provider.of<PageModel>(context, listen: false);
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Provider(
          create: (context) => model,
          child: RegistrationCancellationConfirmIOSDialog(),
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Provider(
          create: (context) => model,
          child: RegistrationCancellationConfirmAndroidDialog(),
        );
      },
    );
  }
}

Future<void> showLoading() async {
  if (EasyLoading.isShow) {
    return;
  }

  await EasyLoading.show(
    maskType: EasyLoadingMaskType.black,
  );
}

Future<void> hideLoading() async {
  await EasyLoading.dismiss();
}

void showException(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

class RegistrationCancellationConfirmAndroidDialog extends StatelessWidget {
  RegistrationCancellationConfirmAndroidDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildAndroidAlerDialog(context);
  }

  Widget buildAndroidAlerDialog(BuildContext context) {
    PageModel model = Provider.of<PageModel>(context);
    return AlertDialog(
      backgroundColor: whiteColor,
      title: Text(
        AppLocalizations.of(context).translate('message-registration-title'),
        style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
      ),
      content: Text(
        AppLocalizations.of(context).translate('message-registration-content'),
        style: TextStyle(color: blackColor),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context).translate('message-registration-no'),
            style: TextStyle(
              color: blackColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await model.cancelRegistration();
            Navigator.pop(context);
          },
          child: Text(
            AppLocalizations.of(context).translate('message-registration-yes'),
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class RegistrationCancellationConfirmIOSDialog extends StatelessWidget {
  RegistrationCancellationConfirmIOSDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildIOSAlerDialog(context);
  }

  Widget buildIOSAlerDialog(BuildContext context) {
    PageModel model = Provider.of<PageModel>(context);
    return CupertinoAlertDialog(
      title: new Text(
        AppLocalizations.of(context).translate('message-registration-title'),
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: new Text(
          AppLocalizations.of(context)
              .translate('message-registration-content'),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            AppLocalizations.of(context).translate('message-registration-no'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            AppLocalizations.of(context).translate('message-registration-yes'),
          ),
          isDestructiveAction: true,
          onPressed: () async {
            await model.cancelRegistration();
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
