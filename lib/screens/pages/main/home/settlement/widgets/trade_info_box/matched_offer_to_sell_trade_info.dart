import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/contract_status.dart';
import '../../models/trade_info.dart';
import '../dated_trade_detail_box.dart';

class MatchedOfferToSellTradeInfoBox extends StatelessWidget {
  final MatchedOfferToSellTradeInfo tradeInfo;
  final bool defaultExpanded;

  const MatchedOfferToSellTradeInfoBox({
    Key? key,
    required this.tradeInfo,
    this.defaultExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeStart = tradeInfo.date;

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
      direction: TransferDirection.OFFER_TO_SELL,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: ContractStatus.MATCHED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedTradeDetailBoxItem(
          name: 'Commited amount',
          value: '${tradeInfo.amount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'Offer to sell ',
          value: '${tradeInfo.offerToSell.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'Trading Fee',
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Estimated Sales ',
          value: '${tradeInfo.estimatedSales.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
