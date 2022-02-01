import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

class ForecastGraph extends StatelessWidget {
  final List<double?> forecastData;
  final List<double?> forecastPvData;
  final List<double?> pvData;
  final List<double?> forecastLoadData;
  final List<double?> loadData;

  final DateTime startHour;

  const ForecastGraph({
    Key? key,
    required this.forecastData,
    required this.forecastPvData,
    required this.pvData,
    required this.forecastLoadData,
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
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forecast Excess PV / Grid Used',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
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
                    forecastPvData: forecastPvData,
                    loadData: loadData,
                    forecastLoadData: forecastLoadData,
                  ),
                ],
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
        _TopologyBottom(),
      ],
    );
  }
}

class _TopologyBottom extends StatelessWidget {
  const _TopologyBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
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
              child: Text('Actual PV'),
            ),
            SizedBox(
              width: 10,
              height: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFA1FC7F).withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Forecast PV'),
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
              child: Text('Actual Load'),
            ),
            SizedBox(
              width: 10,
              height: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE75E57).withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Forecast Load'),
            )
          ],
        ),
      ),
    );
  }
}

class _LineGraph extends StatelessWidget {
  final List<double?> forecastPvData;
  final List<double?> pvData;

  final List<double?> forecastLoadData;
  final List<double?> loadData;

  const _LineGraph({
    Key? key,
    required this.forecastPvData,
    required this.pvData,
    required this.forecastLoadData,
    required this.loadData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(24 * 45, 220),
      painter: _LineGraphPainter(
        forecastPvData: forecastPvData,
        pvData: pvData,
        forecastLoadData: forecastLoadData,
        loadData: loadData,
      ),
    );
  }
}

enum _LineGraphTextBaseline {
  Top,
  Bottom,
}

class _LineGraphPainter extends CustomPainter {
  final List<double?> forecastPvData;
  final List<double?> pvData;

  final List<double?> forecastLoadData;
  final List<double?> loadData;

  get forecastLoadMaxValue =>
      forecastLoadData.reduce((a, b) => max(a ?? 0, b ?? 0) ?? 0);
  get forecastLoadMinValue =>
      forecastLoadData.reduce((a, b) => min(a ?? 0, b ?? 0) ?? 0);

  get forecastPvMaxValue =>
      forecastPvData.reduce((a, b) => max(a ?? 0, b ?? 0));
  get forecastPvMinValue =>
      forecastPvData.reduce((a, b) => min(a ?? 0, b ?? 0));

  get pvMaxValue => pvData.reduce((a, b) => max(a ?? 0, b ?? 0));
  get loadMaxValue => loadData.reduce((a, b) => max(a ?? 0, b ?? 0));

  get loadMinValue => loadData
      .where((element) => element != null)
      .reduce((a, b) => min(a ?? 0, b ?? 0));
  get pvMinValue => pvData
      .where((element) => element != null)
      .reduce((a, b) => min(a ?? 0, b ?? 0));

  get maxValue => max<double>(
      max<double>(max<double>(pvMaxValue, loadMaxValue), forecastPvMaxValue),
      forecastLoadMaxValue);
  get minValue => min<double>(
      min<double>(min<double>(pvMinValue, loadMinValue), forecastPvMinValue),
      forecastLoadMinValue);

  _LineGraphPainter({
    required this.forecastPvData,
    required this.pvData,
    required this.forecastLoadData,
    required this.loadData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawForecastPvPaths(canvas);
    _drawForecastLoadPaths(canvas);

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

  List<Path> _drawLoadPaths(Canvas canvas) {
    return _drawData(canvas, loadColor, loadData, offset: 1);
  }

  List<Path> _drawForecastPvPaths(Canvas canvas) {
    return _drawData(
      canvas,
      pvColor.withOpacity(0.5),
      forecastPvData,
      isDashed: true,
      fontColor: Colors.white.withOpacity(0.5),
      textBaseline: _LineGraphTextBaseline.Bottom,
    );
  }

  List<Path> _drawForecastLoadPaths(Canvas canvas) {
    return _drawData(
      canvas,
      loadColor.withOpacity(0.5),
      forecastLoadData,
      isDashed: true,
      offset: 1,
      fontColor: Colors.white.withOpacity(0.5),
      textBaseline: _LineGraphTextBaseline.Bottom,
    );
  }

  List<Path> _drawData(
    Canvas canvas,
    Color color,
    List<double?> datas, {
    bool isDashed = false,
    double dashSize = 4,
    double dashSpaceSize = 3,
    int offset = 0,
    double fontSize = 8.5,
    Color fontColor = const Color(0xFFFFFFFFF),
    _LineGraphTextBaseline textBaseline = _LineGraphTextBaseline.Top,
  }) {
    List<Path> paths = [];

    Path currentPath = Path();
    bool hasPainted = false;

    var maxValue = this.maxValue;
    var minValue = this.minValue;
    var range = maxValue - minValue;

    minValue = range == 0 ? -1 : minValue;
    maxValue = range == 0 ? 1 : maxValue;
    range = range == 0 ? 2 : range;

    double dataX = 65;
    for (var data in datas) {
      if (data == null) {
        if (hasPainted) {
          paths.add(currentPath);
          currentPath = Path();
          hasPainted = false;
        }
      }

      if (data != null) {
        final dataHeight = (data - minValue).abs() / range * 200;
        final dataY = 220 - dataHeight - 10 + offset;

        try {
          TextSpan span = TextSpan(
            text: '${data.toStringAsFixed(3)}',
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
            ),
          );
          TextPainter textPainter = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(minWidth: 50, maxWidth: 50);

          double textOffset = -fontSize - 2;
          if (textBaseline == _LineGraphTextBaseline.Bottom) {
            textOffset = 2;
          }

          textPainter.paint(canvas, Offset(dataX, max(0, dataY + textOffset)));
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

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (isDashed) {
      for (var path in paths) {
        final metrics = path.computeMetrics().toList();
        final dashStep = dashSize + dashSpaceSize;

        for (final metric in metrics) {
          for (double i = 0; i < metric.length; i += dashStep) {
            final pathDash = metric.extractPath(i, i + dashSize);
            canvas.drawPath(pathDash, paint);
          }
        }
      }
    } else {
      for (var path in paths) {
        canvas.drawPath(path, paint);
      }
    }

    return paths;
  }

  List<Path> _drawPvPaths(Canvas canvas) {
    return _drawData(canvas, pvColor, pvData);
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
                  child: FittedBox(
                    child: Text(
                      value.abs().toStringAsFixed(3),
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
