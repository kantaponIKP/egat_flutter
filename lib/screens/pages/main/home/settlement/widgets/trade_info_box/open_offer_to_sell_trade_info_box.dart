import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/trade_info.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/contract_status.dart';
import '../dated_trade_detail_box.dart';

class OpenOfferToSellTradeInfoBox extends StatelessWidget {
  final OpenOfferToSellTradeInfo tradeInfo;
  final bool defaultExpanded;

  const OpenOfferToSellTradeInfoBox({
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

    final dateText = "${AppLocalizations.of(context).translate('settlement-deliveryTime')} $timeStartString-$timeEndString";

    return DatedTradeDetail(
      direction: TransferDirection.OFFER_TO_SELL,
      date: Text(dateText),
      contractId: null,
      status: ContractStatus.OPEN,
      targetName: null,
      defaultExpanded: defaultExpanded,
      items: [
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-order-amount'),
          value: '${tradeInfo.amount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-offerToSell'),
          value: '${tradeInfo.offerToSell.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-tradingFee'),
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-order-estimatedSales'),
          value: '${tradeInfo.estimatedSales.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
      ],
    );
  }
}
