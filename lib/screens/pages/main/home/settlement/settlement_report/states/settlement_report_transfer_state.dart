import 'package:egat_flutter/screens/pages/main/home/settlement/models/energy_transfer_info.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

import '../../models/trade_info.dart';
import '../apis/energy_transfer_api.dart';

class SettlementReportState extends ChangeNotifier {
  LoginSession? _loginSession;
  List<EnergyTransferInfo> _energyTransferInfos = [];

  LoginSession? get loginSession => _loginSession;
  List<EnergyTransferInfo> get energyTransferInfos => _energyTransferInfos;

  Future<void> fetchOrderAtTime(DateTime selectedTime) async {
    if (loginSession == null) {
      throw new Exception("No login session provided.");
    }

    final accessToken = loginSession!.info!.accessToken;

    final response = await energyTransferApi.fetchEnergyTransferInfos(
      date: selectedTime,
      accessToken: accessToken,
    );

    _energyTransferInfos = response;

    notifyListeners();
  }

  setLoginSession(LoginSession? session) {
    _loginSession = session;
  }
}
