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

    return DatedEnergyDetail(
      direction: TransferDirection.CHOOSE_TO_BUY,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: EnergyTransferStatus.SCHEDULED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: AppLocalizations.of(context).translate('settlement-commitedAmount'),
          value: '${tradeInfo.commitedAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET Buy',
          value: '${tradeInfo.netBuy.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET energy price(NET buy/Energy used)',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Energy to buy',
          value: '${tradeInfo.energyToBuy.toStringAsFixed(2)} kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Energy tariff ',
          value: '${tradeInfo.energyTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Energy price',
          value: '${tradeInfo.energyPrice.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Wheeling charge Tariff',
          value: '${tradeInfo.wheelingChargeTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Wheeling charge',
          value: '${tradeInfo.wheelingCharge.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Trading fee',
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'VAT(7%)',
          value: '${tradeInfo.vat.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
      ],
    );
  }
}
