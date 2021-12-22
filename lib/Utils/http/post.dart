import 'package:egat_flutter/Utils/http/httpActionRetry.dart';
import 'package:http/http.dart';

final httpPostJson = ({
  required Uri uri,
  String? accessToken,
  String? body,
  int retryMax = 5,
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
    );
  } else {
    return await httpActionRetry(
      callFunction: () => post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      ),
      retryMax: retryMax,
    );
  }
};