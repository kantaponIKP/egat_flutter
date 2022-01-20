import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentState extends ChangeNotifier {
  LoginSession loginSession;
  bool _receiveMessage = false;
  bool get currentReceiveMessage => _receiveMessage;

  PaymentState({
    required this.loginSession,
  });

  setLoginSession(LoginSession loginSession) {
    this.loginSession = loginSession;
  }

    String _getUserId() {
    var loginInfo = loginSession.info;
    if (loginInfo == null) {
      throw Exception('No access token');
    }

    return loginInfo.userId;
  }

  setReceiveMessage({
    receiveMessage = "",
  }) {
    this._receiveMessage = receiveMessage;
    notifyListeners();
  }


  void getReceiveMessageFromStorage() async {
    final userId = _getUserId();
    final storage = new FlutterSecureStorage();
    String receiveMessageFromStorage = await storage.read(key: 'receiveMessage_$userId') ?? "";
    bool receiveMessage = receiveMessageFromStorage.toLowerCase() == 'true';
    setReceiveMessage(receiveMessage: receiveMessage);
  }

  void setReceiveMessageToStorage({required bool receiveMessage}) async {
    final userId = _getUserId();
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'receiveMessage_$userId', value: receiveMessage.toString());
  }

}
