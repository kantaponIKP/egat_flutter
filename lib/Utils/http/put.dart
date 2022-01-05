import 'package:egat_flutter/Utils/http/httpActionRetry.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

final httpPutJson = ({
  required Uri uri,
  String? accessToken,
  String? body,
  int retryMax = 5,
}) async {
  if (accessToken != null) {
    return await httpActionRetry(
      callFunction: () => put(
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
      callFunction: () => put(
        uri,
        headers: {
          'Authorization' : 'Basic $authorizationBase64',
          'Content-Type': 'application/json',
        },
        body: body,
      ),
      retryMax: retryMax,
    );
  }
};
