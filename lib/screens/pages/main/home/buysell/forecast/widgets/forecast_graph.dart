import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

class ForecastGraph extends StatelessWidget {
  final List<double?> forecastData;
  final List<double?> pvData;
  final List<double?> loadData;

  final DateTime startHour;

  const ForecastGraph({
    Key? key,
    required this.forecastData,
    required this.pvData,
    required this.loadData,
    required this.startHour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadData = [...this.loadData];
    final nowLimit = DateTime.now().add(Duration(hours: -1));

    for (final entry in loadData.asMap().entries) {
      final entryTime = startHour.add(Duration(hours: entry.key));
      if (entryTime.isAfter(nowLimit)) {
        loadData[entry.key] = null;
      }
    }

    for (final entry in pvData.asMap().entries) {
      final entryTime = startHour.add(Duration(hours: entry.key));
      if (entryTime.isAfter(nowLimit)) {
        pvData[entry.key] = null;
      }
    }

    return Column(
      children: [
        SizedBox(
          width: 45 * 25,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BarGraph(data: forecastData),
                  _ForecastTimeLine(
                    hourCount: 24,
                    startHour: startHour,
                  ),
                  _LineGraph(
                    pvData: pvData,
                    loadData: loadData,
                  ),
                ],
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        _Topology(),
      ],
    );
  }
}

class _Topology extends StatelessWidget {
  const _Topology({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 10,
          height: 10,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFA1FC7F),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('PV'),
        ),
        SizedBox(
          width: 10,
          height: 10,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE75E57),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Load'),
        )
      ],
    );
  }
}

class _LineGraph extends StatelessWidget {
  final List<double?> pvData;
  final List<double?> loadData;

  const _LineGraph({
    Key? key,
    required this.pvData,
    required this.loadData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(24 * 45, 220),
      painter: _LineGraphPainter(
        pvData: pvData,
        loadData: loadData,
      ),
    );
  }
}

class _LineGraphPainter extends CustomPainter {
  final List<double?> pvData;
  final List<double?> loadData;

  get powerMaxValue => loadData.reduce((a, b) => max(a ?? 0, b ?? 0));
  get forecastMaxValue => pvData.reduce((a, b) => max(a ?? 0, b ?? 0));

  get powerForecastMinValue => loadData
      .where((element) => element != null)
      .reduce((a, b) => min(a ?? 0, b ?? 0));
  get forecastForecastMinValue => pvData
      .where((element) => element != null)
      .reduce((a, b) => min(a ?? 0, b ?? 0));

  get maxValue => max<double>(forecastMaxValue, powerMaxValue);
  get minValue => min<double>(forecastForecastMinValue, powerForecastMinValue);

  _LineGraphPainter({
    required this.pvData,
    required this.loadData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawPvPaths(canvas);
    _drawLoadPaths(canvas);

    // _drawFloor(canvas, size);
  }

  @override
  bool shouldRepaint(_LineGraphPainter oldDelegate) {
    return pvData != oldDelegate.pvData;
  }

  @override
  bool shouldRebuildSemantics(_LineGraphPainter oldDelegate) => false;

  final Color loadColor = const Color(0xFFE75E57);
  final Color pvColor = const Color(0xFFA1FC7F);

  void _drawFloor(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 210)
      ..lineTo(size.width, 210);

    canvas.drawPath(path, paint);

    final maxValue = this.maxValue;
    final minValue = this.minValue;
    final range = maxValue - minValue;

    double dataX = 50;

    for (var entry in loadData.asMap().entries) {
      final data = entry.value;

      if (data == null) {
        continue;
      }

      final dataHeight = (data - minValue).abs() / range * 200;
      final dataY = 220 - dataHeight - 10;

      TextSpan span = TextSpan(
        text: '${data.toStringAsFixed(2)}',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
      );

      final textPainter = TextPainter(text: span, textAlign: TextAlign.left);

      textPainter.paint(canvas, Offset(dataX, dataY));

      dataX += 45;
    }

    canvas.drawPath(path, paint);
  }

  List<Path> _drawLoadPaths(Canvas canvas) {
    List<Path> paths = [];

    Path currentPath = Path();
    bool hasPainted = false;

    final maxValue = this.maxValue;
    final minValue = this.minValue;
    final range = maxValue - minValue;

    List<TextPainter> textPainters = [];
    List<double> textPainterOffsetYs = [];
    List<double> textPainterOffsetXs = [];

    double dataX = 65;
    for (var entry in loadData.asMap().entries) {
      final data = entry.value;

      if (data == null) {
        if (hasPainted) {
          paths.add(currentPath);
          currentPath = Path();
          hasPainted = false;
        }
      }

      if (data != null) {
        final dataHeight = (data - minValue).abs() / range * 200;
        final dataY = 220 - dataHeight - 10;

        try {
          TextSpan span = TextSpan(
            text: '${data.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          );
          TextPainter textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(minWidth: 50, maxWidth: 50);

          textPainters.add(textPainter);
          textPainterOffsetYs.add(dataY);
          textPainterOffsetXs.add(dataX);
        } catch (e) {
          print(e);
        }

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

    Paint powerPaint = Paint()
      ..color = loadColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var path in paths) {
      canvas.drawPath(path, powerPaint);
    }

    for (var textPainterEntry in textPainters.asMap().entries) {
      final textPainter = textPainterEntry.value;
      double textPainterOffsetY = textPainterOffsetYs[textPainterEntry.key];
      final textPainterOffsetX = textPainterOffsetXs[textPainterEntry.key];

      final nextValueY = textPainterEntry.key == textPainterOffsetXs.length - 1
          ? textPainterOffsetY
          : textPainterOffsetXs[textPainterEntry.key + 1];

      if (nextValueY >= textPainterOffsetY) {
        textPainterOffsetY -= 10;
      } else {
        textPainterOffsetY += 10;
      }

      textPainter.paint(
        canvas,
        Offset(
          textPainterOffsetX,
          max(0, textPainterOffsetY),
        ),
      );
    }

    return paths;
  }

  List<Path> _drawPvPaths(Canvas canvas) {
    List<Path> paths = [];

    Path currentPath = Path();
    bool hasPainted = false;

    final maxValue = this.maxValue;
    final minValue = this.minValue;
    final range = maxValue - minValue;

    double dataX = 65;
    for (var data in pvData) {
      if (data == null) {
        if (hasPainted) {
          paths.add(currentPath);
          currentPath = Path();
          hasPainted = false;
        }
      }

      if (data != null) {
        final dataHeight = (data - minValue).abs() / range * 200;
        final dataY = 220 - dataHeight - 10;

        try {
          TextSpan span = TextSpan(
            text: '${data.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
          );
          TextPainter textPainter = TextPainter(
              text: span,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr);
          textPainter.layout(minWidth: 50, maxWidth: 50);

          textPainter.paint(canvas, Offset(dataX, max(0, dataY - 10)));
        } catch (e) {
          print(e);
        }

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

    Paint pvPaint = Paint()
      ..color = pvColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var path in paths) {
      canvas.drawPath(path, pvPaint);
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

    return Padding(
      padding: EdgeInsets.only(left: 35),
      child: SizedBox(
        height: 220,
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
    var paddingTop = (110.0 - size);

    if (value < 0) {
      paddingTop = 110.0;
    }

    return Padding(
      padding: EdgeInsets.only(left: 15, top: paddingTop),
      child: AnimatedSize(
        duration: Duration(milliseconds: 0),
        child: SizedBox(
          width: 30,
          height: size,
          child: Expanded(
            child: Container(
              key: this.key,
              color: value > 0 ? Color(0xFFFEC908) : Color(0xFFED8235),
              child: Align(
                alignment:
                    value >= 0 ? Alignment.topCenter : Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    value.abs().toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
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
    var hourFormat = intl.DateFormat('HH:mm');
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
