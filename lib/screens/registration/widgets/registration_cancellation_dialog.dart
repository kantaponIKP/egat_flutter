import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void askForRegistrationCancelConfirmation(BuildContext context) {
  var model = Provider.of<PageModel>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Provider(
        create: (context) => model,
        child: RegistrationCancellationConfirmDialog(),
      );
    },
  );
}

Future<void> showLoading() async {
  if (EasyLoading.isShow) {
    return;
  }

  await EasyLoading.show(
    status: "กรุณารอสักครู่...",
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

class RegistrationCancellationConfirmDialog extends StatelessWidget {
  RegistrationCancellationConfirmDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageModel model = Provider.of<PageModel>(context);

    return AlertDialog(
      title: const Text("ยกเลิกการลงทะเบียน"),
      content: const Text(
        "ต้องการที่จะยกเลิกการลงทะเบียนหรือไม่?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "ไม่ต้องการ",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await model.cancelRegistration();
            Navigator.pop(context);
          },
          child: Text(
            "ต้องการ",
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
