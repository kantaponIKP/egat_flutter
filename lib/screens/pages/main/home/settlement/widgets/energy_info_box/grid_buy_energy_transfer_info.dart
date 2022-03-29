import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../dated_energy_transfer_detail_box.dart';

class GridBuyEnergyTransferInfoBox extends StatelessWidget {
  final GridBuyInfo tradeInfo;
  final bool defaultExpanded;

  const GridBuyEnergyTransferInfoBox({
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
      direction: TransferDirection.GRID_BUY,
      date: Text(dateText),
      contractId: null,
      status: EnergyTransferStatus.COMPLETED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: 'Buy amount(Actual)',
          value: '${tradeInfo.usedAmount.toStringAsFixed(3)} kWh',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET Buy',
          value: '${tradeInfo.netBuy.toStringAsFixed(3)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET energy price(TOU Tariff)',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
