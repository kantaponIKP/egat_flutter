import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../dated_energy_transfer_detail_box.dart';

class ScheduledChooseToBuyEnergyTransferInfoBox extends StatelessWidget {
  final ScheduledChooseToBuyEnergyTransferInfo tradeInfo;
  final bool defaultExpanded;

  const ScheduledChooseToBuyEnergyTransferInfoBox({
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
      direction: TransferDirection.CHOOSE_TO_BUY,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: EnergyTransferStatus.SCHEDULED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-commitedAmount'),
          value: '${tradeInfo.commitedAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-netBuy'),
          value: '${tradeInfo.netBuy.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name:
              '${AppLocalizations.of(context).translate('settlement-netEnergyPrice')}(${AppLocalizations.of(context).translate('settlement-netBuy')}/${AppLocalizations.of(context).translate('settlement-energyUsed')})',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-energyToBuy'),
          value: '${tradeInfo.energyToBuy.toStringAsFixed(2)} kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-energyTariff'),
          value: '${tradeInfo.energyTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name:
              AppLocalizations.of(context).translate('settlement-energyPrice'),
          value: '${tradeInfo.energyPrice.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-wheelingChargeTariff'),
          value: '${tradeInfo.wheelingChargeTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context)
              .translate('settlement-wheelingCharge'),
          value: '${tradeInfo.wheelingCharge.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-tradingFee'),
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-vat'),
          value: '${tradeInfo.vat.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
      ],
    );
  }
}
