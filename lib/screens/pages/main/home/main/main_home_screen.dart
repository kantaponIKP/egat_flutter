import 'dart:async';
import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/main/graph/graph_page.dart';
import 'package:egat_flutter/screens/pages/main/home/main/states/main_selected_date_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'states/main_state.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    super.initState();

    final personalInfo = Provider.of<PersonalInfoState>(context, listen: false);
    bool needPersonalInfoLoading = false;
    if (personalInfo.info.username == null) {
      needPersonalInfoLoading = true;
    }

    final MainScreenTitleState titleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    titleState.setTitleLogo();

    Future.delayed(Duration(milliseconds: 10), () async {
      final MainHomeSelectedDateState dateState =
          Provider.of<MainHomeSelectedDateState>(context, listen: false);

      showLoading();
      try {
        List<Future> futures = [];
        if (needPersonalInfoLoading) {
          futures.add(personalInfo.getPersonalInformation());
        }

        futures.add(dateState.notifyParent());

        await Future.wait(futures);
      } catch (e) {
        showIntlException(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12),
                  _DateSelectionBar(),
                  SizedBox(height: 8),
                  _CurrentTimeDisplay(),
                  _MainSection(),
                ],
              ),
              _SummarySection(),
            ],
          ),
        ),
      );
    });
  }
}

class _MainSection extends StatelessWidget {
  const _MainSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainHomeState>(context);
    final personalInfo = Provider.of<PersonalInfoState>(context);
    final selectedDateState = Provider.of<MainHomeSelectedDateState>(context);

    final dateKeyGetter = (int index) {
      return (index + 1).toStringAsFixed(0);
    };

    final timeFormat = DateFormat('HH');
    final timeKeyGetter = (int index) {
      final newTime = DateTime.now();
      final date = DateTime(newTime.year, newTime.month, newTime.day, index);
      return timeFormat.format(date);
    };

    final dateMonthFormat = DateFormat('MMMM yyyy');
    final dateDayFormat = DateFormat('dd MMMM yyyy');
    final displayGraphTitle = selectedDateState.isDaily
        ? dateDayFormat.format(selectedDateState.selectedDate)
        : dateMonthFormat.format(selectedDateState.selectedDate);

    return AspectRatio(
      aspectRatio: 500 / 400,
      child: FittedBox(
        child: SizedBox(
          width: 500,
          height: 400,
          child: LayoutBuilder(builder: (context, constraints) {
            final percentageY =
                (double percent) => constraints.maxHeight * percent;
            final percentageX =
                (double percent) => constraints.maxWidth * percent;

            final piSweepRatio = (double ratio) => 2 * pi * ratio;

            final double gridInRatio;
            final double gridOutRatio;
            if (state.value.gridInTotal == state.value.gridOutTotal) {
              gridInRatio = 0.5;
              gridOutRatio = 0.5;
            } else if (state.value.gridInTotal == 0) {
              gridInRatio = 0;
              gridOutRatio = 1;
            } else if (state.value.gridOutTotal == 0) {
              gridInRatio = 1;
              gridOutRatio = 0;
            } else {
              gridInRatio = state.value.gridInTotal /
                  (state.value.gridInTotal + state.value.gridOutTotal);
              gridOutRatio = state.value.gridOutTotal /
                  (state.value.gridInTotal + state.value.gridOutTotal);
            }

            return Stack(
              children: [
                Positioned(
                  top: percentageY(0.325),
                  left: percentageX(0.25),
                  right: percentageX(0.25),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: ArcPainter(
                        color: Color(0xFF99FF75),
                        startAngle: -pi / 2,
                        sweepAngle: piSweepRatio(gridInRatio),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: percentageY(0.325),
                  left: percentageX(0.25),
                  right: percentageX(0.25),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: ArcPainter(
                        color: Color(0xFFF6645A),
                        startAngle: -pi / 2 + piSweepRatio(gridInRatio),
                        sweepAngle: piSweepRatio(gridOutRatio),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: percentageY(0.325),
                  left: percentageX(0.25),
                  right: percentageX(0.25),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: MainSummaryGraphic(),
                    ),
                  ),
                ),
                Positioned(
                  top: percentageY(0),
                  bottom: percentageY(0),
                  left: percentageX(0),
                  right: percentageX(0),
                  child: PowerLinePaint(
                    color: Color(0xFF008DC1),
                    direction: PowerDirection.Reverse,
                    start: Offset(percentageX(0.15), percentageY(0.1) + 99),
                    end: Offset(percentageX(0.23), percentageY(0.3) + 99),
                    key: Key('power-line-energy-storage-reverse'),
                  ),
                ),
                Positioned(
                  top: percentageY(0),
                  bottom: percentageY(0),
                  left: percentageX(0),
                  right: percentageX(0),
                  child: PowerLinePaint(
                    color: Color(0xFFF6645A),
                    direction: PowerDirection.Forward,
                    start: Offset(percentageX(0.19), percentageY(0.1) + 99),
                    end: Offset(percentageX(0.27), percentageY(0.2) + 99),
                    key: Key('power-line-energy-storage-supply'),
                  ),
                ),
                Positioned(
                  top: percentageY(0),
                  bottom: percentageY(0),
                  left: percentageX(0),
                  right: percentageX(0),
                  child: PowerLinePaint(
                    color: Color(0xFFF6645A),
                    direction: PowerDirection.Forward,
                    start: Offset(percentageX(0.5), percentageY(0.15) + 45),
                    end: Offset(percentageX(0.5), percentageY(0.19) + 45),
                    key: Key('power-line-solar-supply'),
                  ),
                ),
                Positioned(
                  top: percentageY(0),
                  bottom: percentageY(0),
                  left: percentageX(0),
                  right: percentageX(0),
                  child: PowerLinePaint(
                    color: Color(0xFFF6645A),
                    direction: PowerDirection.Forward,
                    start: Offset(percentageX(0.81), percentageY(0.1) + 99),
                    end: Offset(percentageX(0.73), percentageY(0.2) + 99),
                    key: Key('power-line-grid-supply'),
                  ),
                ),
                Positioned(
                  top: percentageY(0),
                  bottom: percentageY(0),
                  left: percentageX(0),
                  right: percentageX(0),
                  child: PowerLinePaint(
                    color: Color(0xFF99FF75),
                    direction: PowerDirection.Reverse,
                    start: Offset(percentageX(0.85), percentageY(0.1) + 99),
                    end: Offset(percentageX(0.7725), percentageY(0.3) + 99),
                    key: Key('power-line-grid-reverse'),
                  ),
                ),
                Positioned(
                  top: percentageY(0.1),
                  left: percentageX(0.05),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return GraphPage(
                              header: 'Energy Storage',
                              headerIcon: Image.asset(
                                'assets/images/icons/home/battery_icon.png',
                                height: 45,
                                width: 45,
                              ),
                              personalInfo: personalInfo.info,
                              title: displayGraphTitle,
                              valueName: 'Energy Storage (kWh)',
                              total: state.value.batteryInTotal -
                                  state.value.batteryOutTotal,
                              totalUnit: 'kWh',
                              unitName:
                                  selectedDateState.isDaily ? 'เวลา' : 'วันที่',
                              values: [
                                for (var i = 0;
                                    i < state.value.batteryIns.length;
                                    i++)
                                  (state.value.batteryIns.length > i
                                          ? state.value.batteryIns[i]
                                          : 0) -
                                      (state.value.batteryOuts.length > i
                                          ? state.value.batteryOuts[i]
                                          : 0),
                              ],
                              keyGetter: selectedDateState.isDaily
                                  ? timeKeyGetter
                                  : dateKeyGetter,
                            );
                          },
                        ),
                      );
                    },
                    child: _InfoWithIcon(
                      icon: Image.asset(
                        'assets/images/icons/home/battery_icon.png',
                        height: 45,
                        width: 45,
                      ),
                      label: AppLocalizations.of(context)
                          .translate('home-energyStorage'),
                      unit: 'kWh',
                      value1: state.value.batteryInTotal,
                      value1Color: Color(0xFF008DC1),
                      value2: state.value.batteryOutTotal,
                      value2Color: Color(0xFFF6645A),
                    ),
                  ),
                ),
                Positioned(
                  top: percentageY(0.05),
                  left: percentageX(0),
                  right: percentageX(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return GraphPage(
                                  header: 'PV',
                                  headerIcon: Image.asset(
                                    'assets/images/icons/home/battery_icon.png',
                                    height: 45,
                                    width: 45,
                                  ),
                                  personalInfo: personalInfo.info,
                                  title: displayGraphTitle,
                                  valueName: 'PV (kWh)',
                                  total: state.value.pvTotal,
                                  totalUnit: 'kWh',
                                  unitName: selectedDateState.isDaily
                                      ? 'เวลา'
                                      : 'วันที่',
                                  values: state.value.pvs,
                                  keyGetter: selectedDateState.isDaily
                                      ? timeKeyGetter
                                      : dateKeyGetter,
                                );
                              },
                            ),
                          );
                        },
                        child: _InfoWithIcon(
                          icon: Image.asset(
                            'assets/images/icons/home/solar_icon.png',
                            height: 45,
                            width: 45,
                          ),
                          label: 'PV',
                          unit: 'kWh',
                          value1: state.value.pvTotal,
                          value1Color: Color(0xFFF6645A),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: percentageY(0.1),
                  right: percentageX(0.05),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return GraphPage(
                              header: 'Grid',
                              headerIcon: Image.asset(
                                'assets/images/icons/home/grid_icon.png',
                                height: 45,
                                width: 45,
                              ),
                              personalInfo: personalInfo.info,
                              title: displayGraphTitle,
                              valueName: 'Grid (kWh)',
                              total: state.value.gridInTotal -
                                  state.value.gridOutTotal,
                              totalUnit: 'kWh',
                              unitName:
                                  selectedDateState.isDaily ? 'เวลา' : 'วันที่',
                              values: [
                                for (var i = 0;
                                    i < state.value.gridIns.length;
                                    i++)
                                  (state.value.gridOuts.length > i
                                          ? state.value.gridOuts[i]
                                          : 0) -
                                      (state.value.gridIns.length > i
                                          ? state.value.gridIns[i]
                                          : 0),
                              ],
                              keyGetter: selectedDateState.isDaily
                                  ? timeKeyGetter
                                  : dateKeyGetter,
                            );
                          },
                        ),
                      );
                    },
                    child: _InfoWithIcon(
                      icon: Image.asset(
                        'assets/images/icons/home/grid_icon.png',
                        height: 45,
                        width: 45,
                      ),
                      label:
                          AppLocalizations.of(context).translate('home-grid'),
                      unit: 'kWh',
                      value1: state.value.gridOutTotal,
                      value1Color: Color(0xFFF6645A),
                      value2: state.value.gridInTotal,
                      value2Color: Color(0xFF99FF75),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class MainSummaryGraphic extends StatelessWidget {
  const MainSummaryGraphic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainHomeState>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              "assets/images/icons/home/energy_consumption_icon.png",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 8),
            Text(
              state.value.energyConsumption.abs().toStringAsFixed(1),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: state.value.energyConsumption <= 0
                    ? Color(0xFF99FF75)
                    : Color(0xFFF6645A),
              ),
            ),
            SizedBox(width: 4),
            Text(
              'kWh',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: state.value.energyConsumption <= 0
                    ? Color(0xFF99FF75)
                    : Color(0xFFF6645A),
              ),
            ),
          ],
        ),
        Text(
          'Energy Consumption',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 8),
        SvgPicture.asset(
          "assets/images/icons/home/home_summary_icon.svg",
          height: 60,
          width: 60,
        ),
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              "assets/images/icons/home/summary_net_icon.svg",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 8),
            Text(
              state.value.summaryNet.abs().toStringAsFixed(2),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: state.value.summaryNet <= 0
                    ? Color(0xFF99FF75)
                    : Color(0xFFF6645A),
              ),
            ),
            SizedBox(width: 4),
            Text(
              'Baht',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: state.value.summaryNet <= 0
                    ? Color(0xFF99FF75)
                    : Color(0xFFF6645A),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Summary NET',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

enum PowerDirection {
  Forward,
  Reverse,
}

class PowerLinePaint extends StatefulWidget {
  final Color color;
  final PowerDirection direction;
  final Offset start;
  final Offset end;
  final Duration duration;

  const PowerLinePaint({
    Key? key,
    required this.color,
    required this.direction,
    required this.start,
    required this.end,
    this.duration = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  _PowerLinePaintState createState() => _PowerLinePaintState();
}

class _PowerLinePaintState extends State<PowerLinePaint>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    final _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    Tween<double> _rotationTween = Tween(begin: 0, end: 1);

    _rotationTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _controller.repeat();
          } else if (status == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
      );

    _controller.forward();

    this._controller = _controller;
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PowerLinePainter(
        color: widget.color,
        direction: widget.direction,
        start: widget.start,
        end: widget.end,
        progression: _controller?.value ?? 0,
      ),
    );
  }
}

class PowerLinePainter extends CustomPainter {
  final Color color;
  final PowerDirection direction;
  final Offset start;
  final Offset end;
  final double progression;

  final int radius = 16;

  const PowerLinePainter({
    required this.color,
    required this.direction,
    required this.start,
    required this.end,
    required this.progression,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = _drawLine(canvas, paint);
    _drawDot(canvas, path);
  }

  Path _drawLine(Canvas canvas, Paint paint) {
    final startPoint = start;
    final endPoint = end;

    final directionXSign = (startPoint.dx - endPoint.dx).sign;
    final directionYSign = (startPoint.dy - endPoint.dy).sign;

    final corner1 =
        Offset(startPoint.dx, endPoint.dy + radius * directionYSign);
    final corner2 = Offset(startPoint.dx, endPoint.dy);
    final corner3 =
        Offset(startPoint.dx - radius * directionXSign, endPoint.dy);

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy)
      ..lineTo(corner1.dx, corner1.dy)
      ..quadraticBezierTo(corner2.dx, corner2.dy, corner3.dx, corner3.dy)
      ..lineTo(endPoint.dx, endPoint.dy);

    canvas.drawPath(Path.from(path), paint);

    return path;
  }

  @override
  bool shouldRepaint(PowerLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.direction != direction ||
        oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.progression != progression;
  }

  @override
  bool shouldRebuildSemantics(PowerLinePainter oldDelegate) {
    return false;
  }

  final _progressionOffset = 0.1;

  void _drawDot(Canvas canvas, Path path) {
    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5;

    double progression = this.progression;
    if (direction == PowerDirection.Reverse) {
      progression = 1 - progression;
    }

    if (progression >= 1 || progression <= 0) {
      return;
    }

    double gradientRadius = 9;
    if (progression < _progressionOffset) {
      gradientRadius = 9 * progression / _progressionOffset;
      progression = 0;
    }

    if (progression > (1 - _progressionOffset)) {
      gradientRadius = 9 * (1 - progression) / _progressionOffset;
      progression = 1;
    }

    progression =
        (progression - _progressionOffset) * 1 / ((1 - _progressionOffset) / 2);

    if (progression < 0) {
      progression = 0;
    } else if (progression > 1) {
      progression = 1;
    }

    final metrics = path.computeMetrics().toList();

    double totalLength = 0;
    for (final metric in metrics) {
      totalLength += metric.length;
    }

    double currentOffset = 0;
    for (final metric in metrics) {
      final startPercentage = currentOffset / totalLength;
      final endPercentage = (currentOffset + metric.length) / totalLength;

      if (startPercentage >= progression || endPercentage <= progression) {
        currentOffset += metric.length;
        continue;
      }

      final lengthNeeded = (progression - startPercentage) * metric.length;
      final extractedPath = metric.extractPath(lengthNeeded, lengthNeeded);

      final bound = extractedPath.getBounds();

      final offset = Offset(bound.right + 0.125, bound.bottom);
      canvas.drawCircle(offset, 3, dotPaint);

      final Paint gradientPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(center: offset, radius: gradientRadius));

      canvas.drawCircle(offset, gradientRadius, gradientPaint);

      break;
    }

    // final extractedPath
  }

  void calculateCurrentDotPosition() {}
}

class ArcPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final Color color;

  const ArcPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(ArcPainter oldDelegate) {
    return oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.color != color;
  }

  @override
  bool shouldRebuildSemantics(ArcPainter oldDelegate) {
    return oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.color != color;
  }
}

class _InfoWithIcon extends StatelessWidget {
  final Widget icon;
  final String label;
  final String unit;
  final double value1;
  final double? value2;
  final Color value1Color;
  final Color? value2Color;

  const _InfoWithIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.unit,
    required this.value1,
    this.value2,
    required this.value1Color,
    this.value2Color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [
      Text(
        "${value1.toStringAsFixed(1)} $unit",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: value1Color,
        ),
      ),
    ];

    if (value2 != null) {
      rows.add(SizedBox(width: 4));
      rows.add(
        Text(
          "${value2?.toStringAsFixed(1)} $unit",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: value2Color,
          ),
        ),
      );
    }

    return SizedBox(
      width: 130,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          FittedBox(
            child: Row(
              children: rows,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainHomeState>(context);

    final personalInfo = Provider.of<PersonalInfoState>(context);
    final selectedDateState = Provider.of<MainHomeSelectedDateState>(context);

    final dateKeyGetter = (int index) {
      return (index + 1).toStringAsFixed(0);
    };

    final timeFormat = DateFormat('HH');
    final timeKeyGetter = (int index) {
      final newTime = DateTime.now();
      final date = DateTime(newTime.year, newTime.month, newTime.day, index);
      return timeFormat.format(date);
    };

    final dateMonthFormat = DateFormat('MMMM yyyy');
    final dateDayFormat = DateFormat('dd MMMM yyyy');
    final displayGraphTitle = selectedDateState.isDaily
        ? dateDayFormat.format(selectedDateState.selectedDate)
        : dateMonthFormat.format(selectedDateState.selectedDate);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate('home-energyCanBeSold'),
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        max(0, state.value.totalSaleForecastUnit)
                            .toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'kWh',
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color(0xFF939393),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total ${state.value.totalRec.toStringAsFixed(3)} REC',
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color(0xFFB9B9B9),
                    ),
                  ),
                  Text(
                    'Acc ${state.value.accumulatedRec.toStringAsFixed(3)} REC',
                    style: TextStyle(
                      fontSize: 10,
                      color: const Color(0xFFB9B9B9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GraphPage(
                          header: 'Trade Sell',
                          headerIcon: SvgPicture.asset(
                            'assets/images/icons/home/net_sales_icon.svg',
                            height: 45,
                            width: 45,
                          ),
                          personalInfo: personalInfo.info,
                          title: displayGraphTitle,
                          valueName: 'Trade Sell (Baht)',
                          total: state.value.totalSales,
                          totalUnit: 'Baht',
                          unitName:
                              selectedDateState.isDaily ? 'เวลา' : 'วันที่',
                          values: state.value.sales,
                          keyGetter: selectedDateState.isDaily
                              ? timeKeyGetter
                              : dateKeyGetter,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: _SummaryBox(
                    label: AppLocalizations.of(context)
                        .translate('home-tradeSell'),
                    value: state.value.totalSales,
                    unit: 'Baht',
                    valueColor: Color(0xFF99FF75),
                    icon: SvgPicture.asset(
                        'assets/images/icons/home/net_sales_icon.svg'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GraphPage(
                          header: 'Trade Buy',
                          headerIcon: SvgPicture.asset(
                            'assets/images/icons/home/net_buy_icon.svg',
                            height: 45,
                            width: 45,
                          ),
                          personalInfo: personalInfo.info,
                          title: displayGraphTitle,
                          valueName: 'Trade Buy (Baht)',
                          total: state.value.totalBuys,
                          totalUnit: 'Baht',
                          unitName:
                              selectedDateState.isDaily ? 'เวลา' : 'วันที่',
                          values: state.value.buys,
                          keyGetter: selectedDateState.isDaily
                              ? timeKeyGetter
                              : dateKeyGetter,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: _SummaryBox(
                    label:
                        AppLocalizations.of(context).translate('home-tradeBuy'),
                    value: state.value.totalSales,
                    unit: 'Baht',
                    valueColor: Color(0xFFF6645A),
                    icon: SvgPicture.asset(
                        'assets/images/icons/home/net_buy_icon.svg'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return GraphPage(
                          header: 'Grid Used',
                          headerIcon: Image.asset(
                            'assets/images/icons/home/net_buy_from_grid_icon.png',
                            height: 45,
                            width: 45,
                          ),
                          personalInfo: personalInfo.info,
                          title: displayGraphTitle,
                          valueName: 'Grid Used (Baht)',
                          total: state.value.totalBuyFromGrid,
                          totalUnit: 'Baht',
                          unitName:
                              selectedDateState.isDaily ? 'เวลา' : 'วันที่',
                          values: state.value.buyFromGrids,
                          keyGetter: selectedDateState.isDaily
                              ? timeKeyGetter
                              : dateKeyGetter,
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: _SummaryBox(
                    label:
                        AppLocalizations.of(context).translate('home-gridUsed'),
                    value: state.value.totalSales,
                    unit: 'Baht',
                    valueColor: Color(0xFFF6645A),
                    icon: Image.asset(
                        'assets/images/icons/home/net_buy_from_grid_icon.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final Widget icon;
  final double value;
  final String unit;
  final String label;
  final Color valueColor;
  final Function()? onTap;

  _SummaryBox({
    Key? key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
    required this.valueColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF262729),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 85,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    icon,
                    FittedBox(
                      child: Text(
                        "${value.toStringAsFixed(2)} $unit",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: valueColor,
                        ),
                      ),
                    ),
                    Text(label, style: TextStyle(fontSize: 12),textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentTimeDisplay extends StatefulWidget {
  _CurrentTimeDisplay({Key? key}) : super(key: key);

  @override
  _CurrentTimeDisplayState createState() => _CurrentTimeDisplayState();
}

class _CurrentTimeDisplayState extends State<_CurrentTimeDisplay> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();

      if (_currentTime.year != now.year ||
          _currentTime.month != now.month ||
          _currentTime.day != now.day ||
          _currentTime.hour != now.hour ||
          _currentTime.minute != now.minute) {
        setState(() {
          _currentTime = now;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(
      'dd MMMM yyyy',
      AppLocalizations.of(context).getLocale().toString(),
    );
    final timeFormat = DateFormat('HH:mm');

    final dateString = dateFormat.format(_currentTime);
    final timeString = timeFormat.format(_currentTime);

    return Text(
      "$dateString เวลา $timeString",
      style: TextStyle(
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
}

class _DateSelectionBar extends StatelessWidget {
  const _DateSelectionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 4,
          ),
          child: _YearSelectionDropdown(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 4,
          ),
          child: _MonthSelectionDropdown(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 8,
          ),
          child: _DateSelectionDropdown(),
        ),
        Flexible(
          flex: 3,
          // fit: FlexFit.tight,
          child: Container(),
        ),
        _DateSelectModeSwitch(),
        SizedBox(width: 5)
      ],
    );
  }
}

class _DateSelectModeSwitch extends StatelessWidget {
  const _DateSelectModeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<MainHomeSelectedDateState>(context);

    return Row(
      children: [
        Text(AppLocalizations.of(context).translate('home-daily')),
        Switch(
          value: selectedDateState.isDaily,
          activeColor: primaryColor,
          onChanged: (_) {
            if (selectedDateState.isMonthly) {
              selectedDateState.setDaily();
            } else {
              selectedDateState.setMonthly();
            }
          },
        ),
      ],
    );
  }
}

class _DateSelectionDropdown extends StatelessWidget {
  const _DateSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<MainHomeSelectedDateState>(context);

    if (selectedDateState.isMonthly) {
      return Container();
    }

    final selectedDate = selectedDateState.selectedDate;

    final now = DateTime.now();

    final selectableDates = <DateTime>[];
    if (now.month == selectedDate.month && now.year == selectedDate.year) {
      for (var i = 0; i < now.day; i++) {
        selectableDates.add(
          DateTime(selectedDate.year, selectedDate.month, i + 1),
        );
      }
    } else {
      final daysInMonth =
          DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

      for (var i = 0; i < daysInMonth; i++) {
        selectableDates.add(
          DateTime(selectedDate.year, selectedDate.month, i + 1),
        );
      }
    }

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<DateTime>(
        value: selectedDate,
        icon: Icon(Icons.arrow_drop_down_rounded),
        iconSize: 20,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (DateTime? newValue) {
          if (newValue != null) {
            final newDate = DateTime(
              newValue.year,
              newValue.month,
              newValue.day,
            );
            _setSelectedDate(context, selectedDateState, newDate);
          }
        },
        items: selectableDates.map((
          DateTime item,
        ) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              DateFormat('d').format(item.toLocal()),
            ),
          );
        }).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }

  _setSelectedDate(
    BuildContext context,
    MainHomeSelectedDateState selectedTimeState,
    DateTime newDate,
  ) async {
    showLoading();
    try {
      await selectedTimeState.setSelectedDate(newDate);
    } catch (e) {
      showIntlException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}

class _MonthSelectionDropdown extends StatelessWidget {
  const _MonthSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<MainHomeSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final selectedMonth = DateTime(selectedDate.year, selectedDate.month, 1);

    final now = DateTime.now();

    final selectableMonthes = <DateTime>[];
    if (now.year == selectedMonth.year) {
      for (var i = 0; i < now.month; i++) {
        selectableMonthes.add(DateTime(now.year, i + 1, 1));
      }
    } else {
      for (var i = 0; i < 12; i++) {
        selectableMonthes.add(DateTime(selectedMonth.year, i + 1, 1));
      }
    }

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<DateTime>(
        value: selectedMonth,
        icon: Icon(Icons.arrow_drop_down_rounded),
        iconSize: 20,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (DateTime? newValue) {
          if (newValue != null) {
            var newDate = DateTime(
              newValue.year,
              newValue.month,
              selectedDateState.isDaily ? selectedDate.day : 1,
            );

            if (newDate.month != newValue.month) {
              newDate = DateTime(
                newDate.year,
                newDate.month,
                selectedDateState.isDaily ? selectedDate.day : 1,
              );
            }

            _setSelectedDate(context, selectedDateState, newDate);
          }
        },
        items: selectableMonthes.map((
          DateTime item,
        ) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              DateFormat('MMMM',
                      AppLocalizations.of(context).getLocale().toString())
                  .format(item.toLocal()),
            ),
          );
        }).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }

  _setSelectedDate(
    BuildContext context,
    MainHomeSelectedDateState selectedTimeState,
    DateTime newDate,
  ) async {
    showLoading();
    try {
      await selectedTimeState.setSelectedDate(newDate);
    } catch (e) {
      showIntlException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}

class _YearSelectionDropdown extends StatelessWidget {
  const _YearSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<MainHomeSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final selectedYear = DateTime(selectedDate.year);

    final now = DateTime.now();

    final selectableYears = <DateTime>[];
    for (var i = 0; i < 4; i++) {
      selectableYears.add(DateTime(now.year - i));
    }

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<DateTime>(
        value: selectedYear,
        icon: Icon(Icons.arrow_drop_down_rounded),
        iconSize: 20,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (DateTime? newValue) {
          if (newValue != null) {
            var newDate = DateTime(
              newValue.year,
              selectedDate.month,
              selectedDateState.isDaily ? selectedDate.day : 1,
            );

            if (newDate.month != newValue.month) {
              newDate = DateTime(newDate.year, 0);
            }

            _setSelectedDate(context, selectedDateState, newDate);
          }
        },
        items: selectableYears.map((
          DateTime item,
        ) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              DateFormat('yyyy').format(item.toLocal()),
            ),
          );
        }).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }

  _setSelectedDate(
    BuildContext context,
    MainHomeSelectedDateState selectedTimeState,
    DateTime newDate,
  ) async {
    showLoading();
    try {
      await selectedTimeState.setSelectedDate(newDate);
    } catch (e) {
      showIntlException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}
