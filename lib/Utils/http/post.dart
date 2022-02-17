import 'package:egat_flutter/Utils/http/httpActionRetry.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

final httpPostJson = ({
  required Uri uri,
  String? accessToken,
  String? body,
  int retryMax = 5,
  Duration timeout = const Duration(seconds: 15),
}) async {
  if (accessToken != null) {
    return await httpActionRetry(
      callFunction: () => post(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      ),
      retryMax: retryMax,
      timeout: timeout,
      haveAuth: true,
    );
  } else {
    return await httpActionRetry(
      callFunction: () => post(
        uri,
        headers: {
          'Authorization': 'Basic $authorizationBase64',
          'Content-Type': 'application/json',
        },
        body: body,
      ),
      retryMax: retryMax,
      haveAuth: false,
    );
  }
};
