import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
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
      child: Column(
        children: [
          Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xFF99FF75),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-energyTransfer-completed'),
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Color(0xFFF8E295),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-energyTransfer-scheduled'),
                ),
              ),
            ],
          ),
        ],
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
    List<double> committedData = [
      for (var i = 0; i < 24; i++) 0,
    ];
    List<double> actualData = [
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

      double committedValue = 0;
      double actualValue = 0;
      if (data is CompletedBidToBuyEnergyTransferInfo) {
        committedValue = -data.bidedAmount;
        actualValue = -data.energyUsed;
      } else if (data is CompletedChooseToBuyEnergyTransferInfo) {
        committedValue = -data.commitedAmount;
        actualValue = -data.energyUsed;
      } else if (data is CompletedOfferToSellBidEnergyTransferInfo) {
        committedValue = data.offeredAmount;
        actualValue = data.energyDelivered;
      } else if (data is CompletedOfferToSellEnergyTransferInfo) {
        committedValue = data.commitedAmount;
        actualValue = data.energyDelivered;
      } else if (data is ScheduledBidToBuyEnergyTransferInfo) {
        committedValue = -data.bidedAmount;
        actualValue = 0;
      } else if (data is ScheduledChooseToBuyEnergyTransferInfo) {
        committedValue = -data.commitedAmount;
        actualValue = 0;
      } else if (data is ScheduledOfferToSellBidEnergyTransferInfo) {
        committedValue = data.offeredAmount;
        actualValue = 0;
      } else if (data is ScheduledOfferToSellEnergyTransferInfo) {
        committedValue = data.commitedAmount;
        actualValue = 0;
      } else if (data is GridBuyInfo) {
        committedValue = 0;
        actualValue = -data.netBuy;
      } else if (data is GridSellInfo) {
        committedValue = 0;
        actualValue = -data.netSell;
      }

      committedData[diffHours] = committedData[diffHours] + committedValue;
      actualData[diffHours] = actualData[diffHours] + actualValue;
      transferStatuses[diffHours] = data.status;
    }

    double maxValue = 0;
    for (final value in committedData) {
      maxValue = max(maxValue, value.abs());
    }
    for (final value in actualData) {
      maxValue = max(maxValue, value.abs());
    }
    maxValue = max(1, maxValue);

    return Padding(
      padding: const EdgeInsets.only(left: 33),
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var value in committedData.asMap().entries)
              _Bar(
                committedValue: value.value,
                actualValue: actualData[value.key],
                maxValue: maxValue <= 0 ? 1 : maxValue,
                transferStatus: transferStatuses[value.key],
                key: Key('bar-${value.key}'),
              )
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double committedValue;
  final double maxValue;
  final EnergyTransferStatus transferStatus;
  final double actualValue;

  const _Bar({
    Key? key,
    required this.committedValue,
    required this.maxValue,
    required this.transferStatus,
    required this.actualValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var committedSize = committedValue.abs() / maxValue * 100;
    committedSize *= 0.9;
    committedSize = max(1, committedSize);
    var committedPaddingTop = (100.0 - committedSize);

    if (committedValue < 0) {
      committedPaddingTop = 100.0;
    }

    var actualSize = actualValue.abs() / maxValue * 100;
    actualSize *= 0.9;
    actualSize = max(1, actualSize);

    var actualPaddingTop = (100.0 - actualSize);

    if (actualValue < 0) {
      actualPaddingTop = 100.0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12, top: committedPaddingTop),
          child: AnimatedSize(
            duration: Duration(milliseconds: 0),
            child: SizedBox(
              width: 16.7,
              height: committedSize,
              child: Container(
                key: this.key,
                color:
                    committedValue > 0 ? Color(0xFFFEC908) : Color(0xFFED8235),
                child: Align(
                  alignment: committedValue >= 0
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: FittedBox(
                      child: Text(
                        committedValue.abs().toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: actualPaddingTop),
          child: AnimatedSize(
            duration: Duration(milliseconds: 0),
            child: SizedBox(
              width: 16.7,
              height: actualSize,
              child: Container(
                key: this.key,
                color: actualValue > 0 ? Color(0xFFC79D04) : Color(0xFFA15823),
                child: Align(
                  alignment: actualValue >= 0
                      ? Alignment.topCenter
                      : Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: FittedBox(
                      child: Text(
                        actualValue.abs().toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
