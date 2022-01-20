import 'package:egat_flutter/Utils/http/httpActionRetry.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

final httpGetJson = ({
  required Uri url,
  String? accessToken,
  int retryMax = 5,
  Duration timeout = const Duration(seconds: 15),
}) async {
  if (accessToken != null) {
    return await httpActionRetry(
      callFunction: () => get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
      retryMax: retryMax,
      timeout: timeout,
    );
  } else {
    return await httpActionRetry(
      callFunction: () => get(
        url,
        headers: {
          'Authorization': 'Basic $authorizationBase64',
          'Content-Type': 'application/json',
        },
      ),
      retryMax: retryMax,
    );
  }
};
