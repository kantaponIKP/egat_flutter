import 'package:egat_flutter/i18n/app_localizations.dart';
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

    final dateText =
        "${AppLocalizations.of(context).translate('settlement-deliveryTime')} $timeStartString-$timeEndString";

    return DatedTradeDetail(
      direction: TransferDirection.CHOOSE_TO_BUY,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: ContractStatus.MATCHED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedTradeDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-order-amount'),
          value: '${tradeInfo.amount.toStringAsFixed(3)} kWh',
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-energyToBuy'),
          value: '1 THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-energyTariff'),
          value: '${tradeInfo.energyTariff.toStringAsFixed(3)} THB/kWh',
          fontColor: Color(0xFF0329F2),
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-energyPrice'),
          value: '${tradeInfo.energyPrice.toStringAsFixed(3)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-wheelingChargeTariff'),
          value: '${tradeInfo.wheelingChargeTariff.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-wheelingCharge'),
          value: '${tradeInfo.wheelingCharge.toStringAsFixed(3)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-tradingFee'),
          value: '${tradeInfo.tradingFee.toStringAsFixed(3)} THB',
          fontSize: 10,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-netBuy'),
          value: '${tradeInfo.netBuy.toStringAsFixed(3)} THB',
          fontColor: Color(0xFF0329F2),
          fontSize: 13,
        ),
        DatedTradeDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-netEnergyPrice'),
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
