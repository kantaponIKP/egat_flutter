import 'package:egat_flutter/screens/pages/main/home/billing/dialogs/view_previous_invoice_dialog.dart';
import 'package:egat_flutter/screens/pages/main/home/billing/states/billing_selected_date_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'states/billing_state.dart';

class BillingScreen extends StatefulWidget {
  BillingScreen({Key? key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  void initState() {
    super.initState();

    final MainScreenTitleState titleState =
        context.read<MainScreenTitleState>();

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
              _InformationSection(),
            ],
          ),
        ),
      );
    });
  }
}

class _InformationSection extends StatelessWidget {
  const _InformationSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billingState = Provider.of<BillingState>(context);

    if (billingState.billingSummary == null) {
      return Center(child: CircularProgressIndicator());
    }

    final billingSummary = billingState.billingSummary!;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
      child: Column(
        children: [
          _HilightedValueDisplay(
            title: 'Net Energy Trading Payment',
            value:
                '${billingSummary.netEnergyTradingPayment.toStringAsFixed(2)} Baht',
          ),
          _HilightedValueDisplay(
            title: 'Grid Price',
            value: '${billingSummary.gridPrice.toStringAsFixed(2)} Baht',
          ),
          _HilightedValueDisplay(
            title: 'Wheeling Charge',
            value: '${billingSummary.wheelingCharge.toStringAsFixed(2)} Baht',
          ),
          _SummaryValueDisplay(
            title: 'Estimated Net Payment',
            secondaryTitle: '(as of 20 August 2021)',
            value: '${billingSummary.estimatedNetPayment.toStringAsFixed(2)}',
            unit: 'Baht',
          ),
          _Button(
            title: 'View Preliminary Invoice',
            secondaryTitle: 'as of 20 August 2021',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 16),
            child: Divider(
              color: Colors.white,
              thickness: 1,
            ),
          ),
          _Button(
            title: 'View Previous Invoice',
            onTap: () => _showViewPreviousInvoiceDialog(context),
          ),
        ],
      ),
    );
  }

  void _showViewPreviousInvoiceDialog(BuildContext context) async {
    DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return ViewPreviousInvoiceDialog();
      },
    );
  }
}

class _Button extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final void Function()? onTap;

  const _Button({
    Key? key,
    required this.title,
    this.secondaryTitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final members = <Widget>[
      Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    ];

    if (secondaryTitle != null) {
      members.add(Text(
        secondaryTitle!,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black,
        ),
      ));
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFFFeC908),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: members,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryValueDisplay extends StatelessWidget {
  final String title;
  final String secondaryTitle;
  final String value;
  final String unit;

  const _SummaryValueDisplay({
    Key? key,
    required this.title,
    required this.secondaryTitle,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 15,
      ),
      textAlign: TextAlign.left,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const TextSpan(text: '\n'),
                        TextSpan(
                          text: secondaryTitle,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(value, style: const TextStyle(fontSize: 35)),
                  SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(unit, style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HilightedValueDisplay extends StatelessWidget {
  final String title;
  final String value;

  const _HilightedValueDisplay({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        fontSize: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF3E3E3E),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                Text(value),
              ],
            ),
          ),
        ),
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

class _MonthSelectionDropdown extends StatelessWidget {
  const _MonthSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<BillingSelectedDateState>(context);

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
              DateFormat('MMMM yyyy').format(item.toLocal()),
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
    BillingSelectedDateState selectedTimeState,
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

class _DateSelectionDropdown extends StatelessWidget {
  const _DateSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<BillingSelectedDateState>(context);

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
    BillingSelectedDateState selectedTimeState,
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
