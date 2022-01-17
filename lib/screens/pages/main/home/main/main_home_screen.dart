import 'package:egat_flutter/screens/pages/main/home/main/states/main_selected_date_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
            children: [
              SizedBox(height: 12),
              _DateSelectionBar(),
            ],
          ),
        ),
      );
    });
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
            left: 20,
            right: 4,
          ),
          child: _MonthSelectionDropdown(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: _DateSelectionDropdown(),
        ),
        Flexible(
          flex: 3,
          // fit: FlexFit.tight,
          child: Container(),
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
      showException(context, e.toString());
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
    for (var i = 0; i < 24; i++) {
      selectableMonthes.add(DateTime(now.year, now.month - i, 1));
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
              selectedDate.day,
            );

            if (newDate.month != newValue.month) {
              newDate = DateTime(
                newDate.year,
                newDate.month,
                0,
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
      showException(context, e.toString());
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
    for (var i = 0; i < 2; i++) {
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
              selectedDate.day,
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
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}
