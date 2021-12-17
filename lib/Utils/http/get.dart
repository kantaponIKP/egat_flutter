import 'package:egat_flutter/Utils/http/httpActionRetry.dart';
import 'package:http/http.dart';

final httpGetJson = ({
  required Uri url,
  required String accessToken,
  int retryMax = 5,
}) async {
  return await httpActionRetry(
    callFunction: () => get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ),
    retryMax: retryMax,
  );
};
