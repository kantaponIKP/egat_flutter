import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> showLoading() async {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCircle;

  if (EasyLoading.isShow) {
    return;
  }
  await EasyLoading.show(
    maskType: EasyLoadingMaskType.clear,
  );
}

Future<void> hideLoading() async {
  await EasyLoading.dismiss();
}
