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
    );
  }

  _buildTotal(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.personalInfo.photo != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(widget.personalInfo.photo!),
                radius: 40,
              )
            : SizedBox(
                width: 40,
                height: 40,
              ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: const Text(
                'ตั้งแต่ในระยะเวลา',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Text(
              '${widget.total.toStringAsFixed(2)} ${widget.totalUnit}',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _GraphViewer extends StatelessWidget {
  final String valueName;
  final String unitName;
  final List<double> values;

  _GraphViewer({
    Key? key,
    required this.valueName,
    required this.unitName,
    required this.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
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
      width: 420,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: values.length * 50 + 100,
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

    for (var value in values) {
      double nowY = maxValue - minValue != 0
          ? (value - minValue) / (maxValue - minValue) * 100 + 100
          : 100;

      nowY = 225 - nowY;

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
