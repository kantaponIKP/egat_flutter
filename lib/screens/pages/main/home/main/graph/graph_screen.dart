import 'dart:convert';
import 'dart:math';

import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GraphScreen extends StatefulWidget {
  final String title;
  final PersonalInfoModel personalInfo;

  final Widget headerIcon;
  final String header;

  final String valueName;
  final String unitName;

  final String Function(int index) keyGetter;
  final List<double> values;

  final double total;
  final String totalUnit;

  GraphScreen({
    Key? key,
    required this.title,
    required this.personalInfo,
    required this.headerIcon,
    required this.header,
    required this.valueName,
    required this.unitName,
    required this.keyGetter,
    required this.values,
    required this.total,
    required this.totalUnit,
  }) : super(key: key);

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: widget.title, secondTitle: ''),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildHeader(context),
              _buildGraph(context),
              _buildTotal(context),
              SizedBox(height: 40),
            ],
          ),
        ),
      );
    });
  }

  _buildHeader(BuildContext context) {
    return Column(
      children: [
        widget.headerIcon,
        Text(widget.header),
      ],
    );
  }

  _buildGraph(BuildContext context) {
    return _GraphViewer(
      unitName: widget.unitName,
      valueName: widget.valueName,
      values: widget.values,
      keyGetter: widget.keyGetter,
    );
  }

  _buildTotal(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.personalInfo.photo != null
            ? CircleAvatar(
                backgroundImage:
                    Image.memory(base64.decode(widget.personalInfo.photo!))
                        .image,
                radius: 50,
              )
            : SizedBox(
                width: 100,
                height: 100,
              ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: const Text(
                'การใช้งานในเวลาที่เลือก',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${widget.total.toStringAsFixed(2)} ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: '${widget.totalUnit}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ]),
            ),
            Text(
              '${widget.personalInfo.username ?? ''}',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                color: Color(0xFFFEC908),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _GraphTimeline extends StatelessWidget {
  final String Function(int index) keyGetter;
  final int length;

  const _GraphTimeline({
    Key? key,
    required this.keyGetter,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < length; i++)
          SizedBox(
            width: 50,
            child: Center(
              child: Text(
                keyGetter(i),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
      ],
    );
  }
}

class _GraphValues extends StatelessWidget {
  final List<double> values;

  const _GraphValues({
    Key? key,
    required this.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (values.length == 0) {
      return Container();
    }

    double previousValue = 0;

    var minValue = values.reduce((a, b) => min(a, b));
    var maxValue = values.reduce((a, b) => max(a, b));

    if (minValue == maxValue) {
      maxValue += 1;
      minValue -= 1;
    }

    for (var entry in values.asMap().entries) {
      final value = entry.value;
      double nextValue =
          values.length > entry.key + 1 ? values[entry.key] : value;

      double nowY = ((0 - minValue) / (maxValue - minValue)) * 280 - 20;

      if (nowY > 280) {
        nowY = 280;
      } else if (nowY < 20) {
        nowY = 20;
      }

      nowY = 300 - nowY;

      if (value > previousValue) {
        children.add(
          Padding(
            padding: EdgeInsets.only(top: max(0, nowY)),
            child: SizedBox(
              width: 50,
              child: Text(
                value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      } else {
        if (value >= nextValue) {
          children.add(
            Padding(
              padding: EdgeInsets.only(top: max(0, nowY)),
              child: SizedBox(
                width: 50,
                child: Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        } else {
          children.add(
            Padding(
              padding: EdgeInsets.only(top: max(0, nowY)),
              child: SizedBox(
                width: 50,
                child: Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }
      }

      previousValue = value;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        height: 300,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _GraphViewer extends StatelessWidget {
  final String valueName;
  final String unitName;
  final List<double> values;
  final String Function(int index) keyGetter;

  _GraphViewer({
    Key? key,
    required this.valueName,
    required this.unitName,
    required this.values,
    required this.keyGetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: FittedBox(
        child: SizedBox(
          width: 600,
          height: 428,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Text(valueName),
              ),
              Positioned(
                bottom: 45,
                right: 10,
                child: Text(unitName),
              ),
              _buildLines(context),
              Positioned(
                top: 40,
                left: 20,
                child: _buildGraphScrollable(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildLines(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: CustomPaint(
          painter: _GraphLinePainter(),
        ),
      );
    });
  }

  Widget _buildGraphScrollable(BuildContext context) {
    return SizedBox(
      width: 540,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SizedBox(
                width: values.length * 50 + 5,
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      CustomPaint(
                        painter: _WideGraphPainter(values: values),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 130,
              child: _buildTimeline(context),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: _buildGraphValues(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return _GraphTimeline(
      keyGetter: keyGetter,
      length: values.length,
    );
  }

  _buildGraphValues(BuildContext context) {
    return _GraphValues(
      values: values,
    );
  }
}

class _WideGraphPainter extends CustomPainter {
  final List<double> values;

  _WideGraphPainter({
    required this.values,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paths = <Path>[];
    if (values.length < 2) {
      return;
    }

    double nowX = 10;

    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);

    Paint linePaint = Paint()
      ..color = Color(0xFFF6645A)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    Paint circlePaint = Paint()
      ..color = Color(0xFFF6645A)
      ..style = PaintingStyle.fill;

    double oldX = 0;
    double oldY = 0;
    bool notDrawn = true;

    double nowLineValue = maxValue.floorToDouble();
    double endLineValue = minValue.ceilToDouble();

    final lineValuePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final lineValueZeroPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    while (nowLineValue >= endLineValue) {
      double nowY = maxValue - minValue != 0
          ? ((nowLineValue - minValue) / (maxValue - minValue)) * 300
          : 150;

      nowY = 300 - nowY;

      final path = Path();
      path.moveTo(0, nowY);
      path.lineTo(size.width, nowY);

      if (nowLineValue == 0) {
        canvas.drawLine(
          Offset(0, nowY),
          Offset(values.length * 50, nowY),
          lineValueZeroPaint,
        );
      } else {
        canvas.drawLine(
          Offset(0, nowY),
          Offset(values.length * 50, nowY),
          lineValuePaint,
        );
      }

      nowLineValue -= 1;
    }

    for (var value in values) {
      double nowY = maxValue - minValue != 0
          ? ((value - minValue) / (maxValue - minValue)) * 300
          : 150;

      nowY = 300 - nowY;

      final path = Path();

      if (notDrawn) {
        path.moveTo(nowX, nowY);
        path.lineTo(nowX, nowY);

        path.lineTo(nowX, nowX);
        notDrawn = false;
      } else {
        path.moveTo(oldX, oldY);
        path.lineTo(nowX, nowY);

        path.lineTo(nowX, nowY);
      }

      canvas.drawCircle(
        Offset(nowX, nowY),
        5,
        circlePaint,
      );

      oldX = nowX;
      oldY = nowY;

      paths.add(path);

      nowX += 50;

      // canvas.drawPath(Path.from(path), linePaint);
    }

    paths.removeAt(0);
    for (var path in paths) {
      final metrics = path.computeMetrics().toList();
      final drawPath = metrics[0].extractPath(10, (metrics[0].length) - 10);

      canvas.drawPath(drawPath, linePaint);

      // final startPath = metrics[0].extractPath(5, 5);
      // final bounds = startPath.getBounds();
      // final center = bounds.center;

      // canvas.drawCircle(
      //   center,
      //   5,
      //   circlePaint,
      // );
    }
  }

  @override
  bool shouldRepaint(_WideGraphPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_WideGraphPainter oldDelegate) => false;
}

class _GraphLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(20, 20);
    path.lineTo(20, size.height - 40);
    path.lineTo(size.width - 40, size.height - 40);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_GraphLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_GraphLinePainter oldDelegate) => false;
}
