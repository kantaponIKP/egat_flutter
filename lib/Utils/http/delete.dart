import 'package:egat_flutter/Utils/http/httpActionRetry.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

final httpDeleteJson = ({
  required Uri url,
  String? accessToken,
  int retryMax = 5,
}) async {
  if (accessToken != null) {
    return await httpActionRetry(
      callFunction: () => delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
      retryMax: retryMax,
      haveAuth: true,
    );
  } else {
    return await httpActionRetry(
      callFunction: () => delete(
        url,
        headers: {
          'Authorization': 'Basic $authorizationBase64',
          'Content-Type': 'application/json',
        },
      ),
      retryMax: retryMax,
      haveAuth: false,
    );
  }
};
