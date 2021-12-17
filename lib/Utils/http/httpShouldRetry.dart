import 'package:http/http.dart';

final httpShouldRetry = (Response response) {
  if (response.statusCode >= 500) {
    return true;
  }

  return false;
};
