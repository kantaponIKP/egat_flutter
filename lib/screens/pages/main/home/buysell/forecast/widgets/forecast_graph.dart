import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ForecastGraph extends StatelessWidget {
  final List<double?> forecastData;
  final List<double?> powerData;

  final DateTime startHour;

  const ForecastGraph({
    Key? key,
    required this.forecastData,
    required this.powerData,
    required this.startHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final powerData = [...this.powerData];
    final nowLimit = DateTime.now().add(Duration(hours: -1));
    for (final entry in powerData.asMap().entries) {
      final entryTime = startHour.add(Duration(hours: entry.key));
      if (entryTime.isAfter(nowLimit)) {
        powerData[entry.key] = null;
      }
    }

    return SizedBox(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _LineGraph(
                forecastData: forecastData,
                powerData: powerData,
              ),
              _ForecastTimeLine(
                hourCount: forecastData.length,
                startHour: startHour,
              ),
              _BarGraph(data: forecastData),
            ],
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class _LineGraph extends StatelessWidget {
  final List<double?> forecastData;
  final List<double?> powerData;

  const _LineGraph({
    Key? key,
    required this.forecastData,
    required this.powerData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: (forecastData.length + 1) * 45,
      child: CustomPaint(
        painter: _LineGraphPainter(
          forecastData: forecastData,
          powerData: powerData,
        ),
      ),
    );
  }
}

class _LineGraphPainter extends CustomPainter {
  final List<double?> forecastData;
  final List<double?> powerData;

  get powerMaxValue => powerData.reduce((a, b) => max(a ?? 0, b ?? 0));
  get forecastMaxValue => forecastData.reduce((a, b) => max(a ?? 0, b ?? 0));

  get maxValue => max<double>(forecastMaxValue, powerMaxValue);

  _LineGraphPainter({
    required this.forecastData,
    required this.powerData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final forecastPaths = getForecastPaths();
    Paint forecastPaint = Paint()
      ..color = forecastColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var path in forecastPaths) {
      canvas.drawPath(path, forecastPaint);
    }

    final powerPaths = getPowerPaths();
    Paint powerPaint = Paint()
      ..color = powerColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var path in powerPaths) {
      canvas.drawPath(path, powerPaint);
    }
  }

  @override
  bool shouldRepaint(_LineGraphPainter oldDelegate) {
    return forecastData != oldDelegate.forecastData;
  }

  @override
  bool shouldRebuildSemantics(_LineGraphPainter oldDelegate) => false;

  final Color powerColor = const Color(0xFFE75E57);
  final Color forecastColor = const Color(0xFFA1FC7F);

  List<Path> getPowerPaths() {
    List<Path> paths = [];

    Path currentPath = Path();
    bool hasPainted = false;

    double dataX = 50;
    for (var entry in powerData.asMap().entries) {
      final data = entry.value;

      if (data == null) {
        if (hasPainted) {
          paths.add(currentPath);
          currentPath = Path();
          hasPainted = false;
        }
      }

      if (data != null) {
        final dataHeight = data / maxValue! * 100;
        final dataY = 100 - dataHeight;

        if (!hasPainted) {
          hasPainted = true;
          currentPath.moveTo(dataX, dataY);
        }

        currentPath.lineTo(dataX, dataY);
      }

      dataX += 45;
    }

    if (hasPainted) {
      paths.add(currentPath);
    }

    return paths;
  }

  List<Path> getForecastPaths() {
    List<Path> paths = [];

    Path currentPath = Path();
    bool hasPainted = false;

    double dataX = 50;
    for (var data in forecastData) {
      if (data == null) {
        if (hasPainted) {
          paths.add(currentPath);
          currentPath = Path();
          hasPainted = false;
        }
      }

      if (data != null) {
        final dataHeight = data / maxValue! * 100;
        final dataY = 100 - dataHeight;

        if (!hasPainted) {
          hasPainted = true;
          currentPath.moveTo(dataX, dataY);
        }

        currentPath.lineTo(dataX, dataY);
      }

      dataX += 45;
    }

    if (hasPainted) {
      paths.add(currentPath);
    }

    return paths;
  }
}

class _BarGraph extends StatefulWidget {
  final List<double?> data;

  _BarGraph({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<_BarGraph> {
  @override
  Widget build(BuildContext context) {
    double maxValue = 0;
    for (final value in widget.data) {
      if (value != null) {
        maxValue = max(maxValue, value.abs());
      }
    }

    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var value in widget.data.asMap().entries)
            value.value != null
                ? _Bar(
                    value: value.value!,
                    maxValue: maxValue <= 0 ? 1 : maxValue,
                    key: Key('bar-${value.key}'))
                : _Bar(
                    value: 0,
                    maxValue: maxValue <= 0 ? 1 : maxValue,
                    key: Key('bar-${value.key}'),
                  ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value;
  final double maxValue;

  const _Bar({
    Key? key,
    required this.value,
    required this.maxValue,
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
            color: value > 0 ? Color(0xFFFEC908) : Color(0xFFED8235),
          ),
        ),
      ),
    );
  }
}

class _ForecastTimeLine extends StatelessWidget {
  final DateTime startHour;
  final int hourCount;

  const _ForecastTimeLine({
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
