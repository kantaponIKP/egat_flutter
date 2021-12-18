import 'package:egat_flutter/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ViewPreviousInvoiceDialog extends StatefulWidget {
  ViewPreviousInvoiceDialog({Key? key}) : super(key: key);

  @override
  _ViewPreviousInvoiceDialogState createState() =>
      _ViewPreviousInvoiceDialogState();
}

class _ViewPreviousInvoiceDialogState extends State<ViewPreviousInvoiceDialog> {
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        width: 272,
        decoration: BoxDecoration(
          color: Color(0xFF3E3E3E),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _buildContent(context),
        ),
      ),
    );
  }

  _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "View Previous Invoice",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFFEC908),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: _MonthSelectionSection(
            selectedMonth: _selectedMonth,
            onMonthChanged: (month) {
              setState(() {
                _selectedMonth = month;
              });
            },
          ),
        )
      ],
    );
  }
}

class _MonthSelectionSection extends StatelessWidget {
  final DateTime selectedMonth;
  final void Function(DateTime)? onMonthChanged;

  const _MonthSelectionSection({
    Key? key,
    required this.selectedMonth,
    this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var selectableYears = <DateTime>[];

    if (now.month != 1) {
      for (var year = now.year; year >= 2019; year--) {
        selectableYears.add(
          DateTime(year, selectedMonth.month, 1),
        );
      }
    } else {
      for (var year = now.year - 1; year >= 2019; year--) {
        selectableYears.add(
          DateTime(year, selectedMonth.month, 1),
        );
      }
    }

    var selectableMonthes = <DateTime>[];
    if (now.year == selectedMonth.year && now.month != 1) {
      for (var month = now.month - 1; month >= 1; month--) {
        selectableMonthes.add(
          DateTime(selectedMonth.year, month, 1),
        );
      }
    } else {
      for (var month = 12; month >= 1; month--) {
        selectableMonthes.add(
          DateTime(selectedMonth.year, month, 1),
        );
      }
    }

    return Column(
      children: [
        _MonthSelectionDropDown(
          selectedMonth: selectedMonth,
          onMonthChanged: onMonthChanged,
        ),
        _YearSelectionDropDown(
          selectedMonth: selectedMonth,
          onMonthChanged: onMonthChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedMonth);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(0, 30),
                  maximumSize: Size(200, 35),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: greyColor,
                  minimumSize: Size(0, 30),
                  maximumSize: Size(200, 35),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthSelectionDropDown extends StatelessWidget {
  final void Function(DateTime)? onMonthChanged;
  final DateTime selectedMonth;

  const _MonthSelectionDropDown({
    Key? key,
    required this.selectedMonth,
    this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    final selectableMonthes = <DateTime>[];
    if (now.year == selectedMonth.year && now.month != 1) {
      for (var month = now.month - 1; month >= 1; month--) {
        selectableMonthes.add(
          DateTime(selectedMonth.year, month, 1),
        );
      }
    } else {
      for (var month = 12; month >= 1; month--) {
        selectableMonthes.add(
          DateTime(selectedMonth.year, month, 1),
        );
      }
    }

    final limitMonthSelection = DateTime(now.year, now.month - 1, 1);

    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        child: DropdownButton<DateTime>(
          value: selectedMonth,
          items: selectableMonthes.map(
            (month) {
              return DropdownMenuItem(
                value: month,
                child: Text(DateFormat.MMMM().format(month)),
              );
            },
          ).toList(),
          onChanged: onMonthChanged != null
              ? (value) {
                  if (value != null) {
                    if (value.isAfter(limitMonthSelection)) {
                      onMonthChanged?.call(
                        DateTime(now.year, now.month - 1, 1),
                      );
                    } else {
                      onMonthChanged?.call(value);
                    }
                  }
                }
              : null,
        ),
      );
    });
  }
}

class _YearSelectionDropDown extends StatelessWidget {
  final void Function(DateTime)? onMonthChanged;
  final DateTime selectedMonth;

  const _YearSelectionDropDown({
    Key? key,
    required this.selectedMonth,
    this.onMonthChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var selectableYears = <DateTime>[];

    if (now.month != 1) {
      for (var year = now.year; year >= 2019; year--) {
        selectableYears.add(
          DateTime(year, selectedMonth.month, 1),
        );
      }
    } else {
      for (var year = now.year - 1; year >= 2019; year--) {
        selectableYears.add(
          DateTime(year, selectedMonth.month, 1),
        );
      }
    }

    final limitMonthSelection = DateTime(now.year, now.month - 1, 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: DropdownButton<DateTime>(
            value: selectedMonth,
            items: selectableYears.map(
              (month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(DateFormat('yyyy').format(month)),
                );
              },
            ).toList(),
            onChanged: onMonthChanged != null
                ? (value) {
                    if (value != null) {
                      if (value.isAfter(limitMonthSelection)) {
                        onMonthChanged?.call(
                          DateTime(now.year, now.month - 1, 1),
                        );
                      } else {
                        onMonthChanged?.call(value);
                      }
                    }
                  }
                : null,
          ),
        );
      },
    );
  }
}
