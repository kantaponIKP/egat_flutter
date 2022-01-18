import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_status.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/energy_transfer_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/trade_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class OrderGraph extends StatelessWidget {
  final List<TradeInfo> energyData;

  final DateTime startHour;

  const OrderGraph({
    Key? key,
    required this.energyData,
    required this.startHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _BarGraph(data: energyData, startHour: startHour),
              _EnergyTransferTimeLine(
                hourCount: 24,
                startHour: startHour,
              ),
            ],
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class _BarGraph extends StatefulWidget {
  final List<TradeInfo> data;
  final DateTime startHour;

  _BarGraph({
    Key? key,
    required this.data,
    required this.startHour,
  }) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<_BarGraph> {
  @override
  Widget build(BuildContext context) {
    List<double> energyData = [
      for (var i = 0; i < 24; i++) 0,
    ];

    List<ContractStatus> contractStatuses = [
      for (var i = 0; i < 24; i++) ContractStatus.OPEN,
    ];

    for (final data in widget.data) {
      final diffHours = data.date.difference(widget.startHour).inHours;
      if (diffHours < 0 || diffHours >= 24) {
        continue;
      }

      double value = 0;
      if (data is OpenOfferToSellTradeInfo) {
        value = data.estimatedSales;
      } else if (data is MatchedOfferToSellTradeInfo) {
        value = data.estimatedSales;
      } else if (data is MatchedChooseToBuyTradeInfo) {
        value = data.netBuy;
      } else if (data is MatchedOfferToSellBidTradeInfo) {
        value = data.estimatedSales;
      } else if (data is MatchedBidToBuyTradeInfo) {
        value = data.marketClearingPrice;
      }

      energyData[diffHours] = energyData[diffHours] + value;
      contractStatuses[diffHours] = data.status;
    }

    double maxValue = 0;
    for (final value in energyData) {
      maxValue = max(maxValue, value.abs());
    }
    maxValue = max(1, maxValue);

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var value in energyData.asMap().entries)
            _Bar(
              value: value.value,
              maxValue: maxValue <= 0 ? 1 : maxValue,
              contractStatus: contractStatuses[value.key],
              key: Key('bar-${value.key}'),
            )
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value;
  final double maxValue;
  final ContractStatus contractStatus;

  const _Bar({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.contractStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = value.abs() / maxValue * 100;
    var paddingTop = (100.0 - size);

    if (value < 0) {
      paddingTop = 100.0;
    }

    return Padding(
      padding: EdgeInsets.only(left: 15, top: paddingTop),
      child: AnimatedSize(
        duration: Duration(milliseconds: 0),
        child: SizedBox(
          width: 30,
          height: size,
          child: Container(
            key: this.key,
            color: contractStatus == ContractStatus.OPEN
                ? Color(0xFFFEC908)
                : (contractStatus == ContractStatus.MATCHED
                    ? Color(0xFF99FF55)
                    : Color(0xFFF6645A)),
          ),
        ),
      ),
    );
  }
}

class _EnergyTransferTimeLine extends StatelessWidget {
  final DateTime startHour;
  final int hourCount;

  const _EnergyTransferTimeLine({
    Key? key,
    required this.startHour,
    required this.hourCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        children: [
          for (var i = 0; i < hourCount + 1; i++)
            _ForecastTimeItem(
              hour: startHour.add(Duration(hours: i)),
            ),
        ],
      ),
    );
  }
}

class _ForecastTimeItem extends StatelessWidget {
  final DateTime hour;
  const _ForecastTimeItem({
    Key? key,
    required this.hour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hourFormat = DateFormat('HH:mm');
    var hourString = hourFormat.format(hour);

    return SizedBox(
      width: 45,
      height: 20,
      child: Text(
        hourString,
        style: TextStyle(
          fontSize: 10,
          color: greyColor,
        ),
      ),
    );
  }
}
