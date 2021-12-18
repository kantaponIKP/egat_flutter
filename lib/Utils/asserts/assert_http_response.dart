import 'package:http/http.dart';

final assertHttpResponse = (
  Response response, {
  required List<int> excludeStatusCodes,
}) {
  if (excludeStatusCodes.contains(response.statusCode)) {
    return;
  }

  if (response.statusCode >= 500) {
    throw Exception('HTTP error: Server error: ${response.statusCode}');
  }

  if (response.statusCode >= 400) {
    throw Exception('HTTP error: Client error: ${response.statusCode}');
  }

  if (response.statusCode >= 300) {
    throw Exception('HTTP error: Redirection error: ${response.statusCode}');
  }
};
