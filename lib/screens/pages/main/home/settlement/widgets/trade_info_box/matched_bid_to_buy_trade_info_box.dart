import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/contract_status.dart';
import '../../models/trade_info.dart';
import '../dated_trade_detail_box.dart';

class MatchedBidToBuyTradeInfoBox extends StatelessWidget {
  final MatchedBidToBuyTradeInfo tradeInfo;
  final bool defaultExpanded;

  const MatchedBidToBuyTradeInfoBox({
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

    final dateText = "${AppLocalizations.of(context).translate('settlement-deliveryTime')} $timeStartString-$timeEndString";

    return DatedTradeDetail(
      direction: TransferDirection.BID_TO_BUY,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: ContractStatus.MATCHED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-bidedAmount'),
          value: '${tradeInfo.biddedAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-matchedAmount'),
          value: '${tradeInfo.matchedAmount.toStringAsFixed(2)} kWh',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-bidToBuy'),
          value: '${tradeInfo.bidToBuy.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-marketClearingPrice'),
          value: '${tradeInfo.marketClearingPrice.toStringAsFixed(2)} THB',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-estimatedBuy'),
          value: '${tradeInfo.estimatedBuy.toStringAsFixed(2)} THB',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-netEstimatedEnergyPrice'),
          value:
              '${tradeInfo.netEstimatedEnergyPrice.toStringAsFixed(2)} THB/kWh',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-energyToBuy'),
          value: '${tradeInfo.energyToBuy.toStringAsFixed(2)} kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-energyTariff'),
          value: '${tradeInfo.energyTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-energyPrice'),
          value: '${tradeInfo.energyPrice.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-wheelingChargeTariff'),
          value: '${tradeInfo.wheelingChargeTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-wheelingCharge'),
          value: '${tradeInfo.wheelingCharge.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-tradingFee'),
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-vat'),
          value: '${tradeInfo.vat.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
      ],
    );
  }
}
