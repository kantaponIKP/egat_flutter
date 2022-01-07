import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/contract_status.dart';
import '../../models/trade_info.dart';
import '../dated_trade_detail_box.dart';

class MatchedOfferToSellBidTradeInfoBox extends StatelessWidget {
  final MatchedOfferToSellBidTradeInfo tradeInfo;
  final bool defaultExpanded;

  const MatchedOfferToSellBidTradeInfoBox({
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
      direction: TransferDirection.OFFER_TO_SELL_BID,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: ContractStatus.MATCHED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedTradeDetailBoxItem(
          name: 'Offered amount',
          value: '${tradeInfo.offeredAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'Matched amount',
          value: '${tradeInfo.matchedAmount.toStringAsFixed(2)} kWh',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'Offer to sell ',
          value: '${tradeInfo.offerToSell.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'Market clearing price',
          value: '${tradeInfo.marketClearingPrice.toStringAsFixed(2)} THB',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: 'Trading Fee',
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: 'Estimated Sales',
          value: '${tradeInfo.estimatedSales.toStringAsFixed(2)} THB',
          fontColor: Color(0xFF0329F2),
          fontSize: 10,
        ),
      ],
    );
  }
}
