import 'dart:convert';

class CardInformation {
  String? cardNumber;
  String? expireDate;
  String? cvvCode;

  CardInformation({
    required this.cardNumber,
    required this.expireDate,
    required this.cvvCode,
  });

  CardInformation.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.cardNumber = jsonMap['cardNumber'];
    this.expireDate = jsonMap['expireDate'];
    this.cvvCode = jsonMap['cvvCode'];
  }

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['cardNumber'] = this.cardNumber;
    jsonMap['expireDate'] = this.expireDate;
    jsonMap['cvvCode'] = this.cvvCode;

    return jsonEncode(jsonMap);
  }


}
