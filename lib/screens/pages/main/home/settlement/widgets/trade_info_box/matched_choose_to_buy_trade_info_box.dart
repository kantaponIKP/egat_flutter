import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/contract_status.dart';
import '../../models/trade_info.dart';
import '../dated_trade_detail_box.dart';

class MatchedChooseToBuyTradeInfoBox extends StatelessWidget {
  final MatchedChooseToBuyTradeInfo tradeInfo;
  final bool defaultExpanded;

  const MatchedChooseToBuyTradeInfoBox({
    Key? key,
    required this.tradeInfo,
    this.defaultExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeStart = tradeInfo.date.toLocal();

    final timeStartHour = DateTime(
      timeStart.year,
      timeStart.month,
      timeStart.day,
      timeStart.hour,
    );

    final dateFormat = DateFormat('HH:mm');
    final timeStartString = dateFormat.format(timeStartHour);
    final timeEndString =
        dateFormat.format(timeStartHour.add(Duration(hours: 1)));

    final dateText = "Delivery Time $timeStartString-$timeEndString";

    return DatedTradeDetail(
      direction: TransferDirection.CHOOSE_TO_BUY,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: ContractStatus.MATCHED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedTradeDetailBoxItem(
          name: 'Amount',
          value: '${tradeInfo.amount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'NET buy',
          value: '${tradeInfo.netBuy.toStringAsFixed(2)} THB',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'NET energy price ',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Energy tariff ',
          value: '${tradeInfo.energyTariff.toStringAsFixed(2)} THB/kWh',
          fontColor: Color(0xFF0329F2),
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Energy price',
          value: '${tradeInfo.energyPrice.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Wheeling charge Tariff',
          value: '${tradeInfo.wheelingChargeTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Wheeling charge',
          value: '${tradeInfo.wheelingCharge.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Trading fee',
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
      ],
    );
  }
}
