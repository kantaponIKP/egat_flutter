import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../dated_energy_transfer_detail_box.dart';

class CompletedOfferToSellEnergyTransferInfoBox extends StatelessWidget {
  final CompletedOfferToSellEnergyTransferInfo tradeInfo;
  final bool defaultExpanded;

  const CompletedOfferToSellEnergyTransferInfoBox({
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

    return DatedEnergyDetail(
      direction: TransferDirection.OFFER_TO_SELL,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: EnergyTransferStatus.COMPLETED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-commitedAmount'),
          value: '${tradeInfo.commitedAmount.toStringAsFixed(3)} kWh',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-energyDelivered'),
          value: '${tradeInfo.energyDelivered.toStringAsFixed(3)} kWh',
          fontSize: 13,
          fontColor: Color(0xFF12875D),
        ),
        DatedEnergyDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-sellingPrice'),
          value: '${tradeInfo.sellingPrice.toStringAsFixed(3)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-sales'),
          value: '${tradeInfo.sales.toStringAsFixed(3)} kWh',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-sellerImbalanceAmount'),
          value: '${tradeInfo.sellerImbalanceAmount.toStringAsFixed(3)} kWh',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-sellerImbalance'),
          value: '${tradeInfo.sellerImbalance.toStringAsFixed(3)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-tradingFee'),
          value: '${tradeInfo.tradingFee.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-netSales'),
          value: '${tradeInfo.netSales.toStringAsFixed(3)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name:
              '${AppLocalizations.of(context).translate('settlement-netEnergyPrice')}(${AppLocalizations.of(context).translate('settlement-netSales')}/${AppLocalizations.of(context).translate('settlement-energyDelivered')})',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
