import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../dated_energy_transfer_detail_box.dart';

class CompletedBidToBuyEnergyTransferInfoBox extends StatelessWidget {
  final CompletedBidToBuyEnergyTransferInfo tradeInfo;
  final bool defaultExpanded;

  const CompletedBidToBuyEnergyTransferInfoBox({
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

    return DatedEnergyDetail(
      direction: TransferDirection.BID_TO_BUY,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: EnergyTransferStatus.COMPLETED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: 'Bided amount(Matched)',
          value: '${tradeInfo.bidedAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
          fontColor: Color(0xFF0329F2),
        ),
        DatedEnergyDetailBoxItem(
          name: 'Energy used',
          value: '${tradeInfo.energyUsed.toStringAsFixed(2)} kWh',
          fontSize: 13,
          fontColor: Color(0xFF12875D),
        ),
        DatedEnergyDetailBoxItem(
          name: 'Market clearing price',
          value: '${tradeInfo.marketClearingPrice.toStringAsFixed(2)} THB/kWh',
          fontSize: 13,
          fontColor: Color(0xFF0329F2),
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
          name: 'Buyer imbalance amount',
          value: '${tradeInfo.buyerImbalanceAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedEnergyDetailBoxItem(
          name: 'Buyer imbalance',
          value: '${tradeInfo.buyerImbalance.toStringAsFixed(2)} THB',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
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
