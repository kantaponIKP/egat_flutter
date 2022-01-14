import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/energy_transfer_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class EnergyTransferGraph extends StatelessWidget {
  final List<EnergyTransferInfo> energyData;

  final DateTime startHour;

  const EnergyTransferGraph({
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
              _EnergyTransferTimeLine(
                hourCount: energyData.length,
                startHour: startHour,
              ),
              _BarGraph(data: energyData, startHour: startHour),
            ],
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class _BarGraph extends StatefulWidget {
  final List<EnergyTransferInfo> data;
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

    List<EnergyTransferStatus> transferStatuses = [
      for (var i = 0; i < 24; i++) EnergyTransferStatus.SCHEDULED,
    ];

    for (final data in widget.data) {
      final diffHours = data.date.difference(widget.startHour).inHours;
      if (diffHours < 0 || diffHours >= 24) {
        continue;
      }

      double value = 0;
      if (data is CompletedBidToBuyEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is CompletedChooseToBuyEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is CompletedOfferToSellBidEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is CompletedOfferToSellEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is ScheduledBidToBuyEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is ScheduledChooseToBuyEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is ScheduledOfferToSellBidEnergyTransferInfo) {
        value = data.netEnergyPrice;
      } else if (data is ScheduledOfferToSellEnergyTransferInfo) {
        value = data.netEnergyPrice;
      }

      energyData[diffHours] = energyData[diffHours] + value;
      transferStatuses[diffHours] = data.status;
    }

    double maxValue = 0;
    for (final value in energyData) {
      maxValue = max(maxValue, value.abs());
    }
    maxValue = min(1, maxValue);

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
              transferStatus: transferStatuses[value.key],
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
  final EnergyTransferStatus transferStatus;

  const _Bar({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.transferStatus,
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
            color: transferStatus == EnergyTransferStatus.COMPLETED
                ? Color(0xFF99FF75)
                : Color(0xFFF89295),
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
