import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> showLoading() async {
  if (EasyLoading.isShow) {
    return;
  }

  await EasyLoading.show(
    // status: "กรุณารอสักครู่...",
    status: "Please wait...",
    maskType: EasyLoadingMaskType.black,
  );
}

Future<void> hideLoading() async {
  await EasyLoading.dismiss();
}