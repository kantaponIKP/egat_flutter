import 'dart:async';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/home/main/states/main_selected_date_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

    final MainScreenTitleState titleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    titleState.setTitleLogo();

    Future.delayed(Duration(milliseconds: 10), () async {
      final MainHomeSelectedDateState dateState =
          Provider.of<MainHomeSelectedDateState>(context, listen: false);

      showLoading();
      try {
        await dateState.notifyParent();
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
      return SizedBox(
        height: constraints.maxHeight,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              _DateSelectionBar(),
              SizedBox(height: 8),
              _CurrentTimeDisplay(),
              _MainSection(),
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
    return AspectRatio(aspectRatio: 1);
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MainHomeState>(context);

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
                    'Energy can be sold in 1 day advance',
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.value.totalSaleForecastUnit.toStringAsFixed(2),
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
                    'Total ${state.value.totalRec.toStringAsFixed(2)} REC',
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
              child: Padding(
                padding: EdgeInsets.all(10),
                child: _SummaryBox(
                  label: 'Trade Sell',
                  value: state.value.totalSales,
                  unit: 'Baht',
                  valueColor: Color(0xFF99FF75),
                  icon: SvgPicture.asset(
                      'assets/images/icons/home/net_sales_icon.svg'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: _SummaryBox(
                  label: 'Trade Buy',
                  value: state.value.totalSales,
                  unit: 'Baht',
                  valueColor: Color(0xFFF6645A),
                  icon: SvgPicture.asset(
                      'assets/images/icons/home/net_buy_icon.svg'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: _SummaryBox(
                  label: 'Grid Used',
                  value: state.value.totalSales,
                  unit: 'Baht',
                  valueColor: Color(0xFFF6645A),
                  icon: SvgPicture.asset(
                      'assets/images/icons/home/net_buy_from_grid_icon.svg'),
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
            height: 70,
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
                        style: TextStyle(fontSize: 15, color: valueColor),
                      ),
                    ),
                    Text(label, style: TextStyle(fontSize: 12)),
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
    final dateFormat = DateFormat('dd MMMM yyyy');
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
        Text('Daily'),
        Switch(
          value: selectedDateState.isMonthly,
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

    if (selectedDateState.isDaily) {
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
      for (var i = 0; i < 12; i++) {
        selectableMonthes.add(DateTime(now.year, i + 1, 1));
      }
    } else {
      for (var i = 0; i <= now.month; i++) {
        selectableMonthes.add(DateTime(now.year, i + 1, 1));
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
              DateFormat('MMMM').format(item.toLocal()),
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
