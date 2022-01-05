import 'package:egat_flutter/constant.dart';
import '../../apis/models/BilateralBuyItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class BuyConfirmationDialog extends StatefulWidget {
  final List<BilateralBuyItem> items;
  final DateTime forDate;

  BuyConfirmationDialog({
    Key? key,
    required this.items,
    required this.forDate,
  }) : super(key: key);

  @override
  _BuyConfirmationDialogState createState() => _BuyConfirmationDialogState();
}

class _BuyConfirmationDialogState extends State<BuyConfirmationDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth;
        if (width > 327) {
          width = 327;
        }

        return Container(
          width: width,
          decoration: BoxDecoration(
            color: Color(0xFF3E3E3E),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildContent(context),
          ),
        );
      }),
    );
  }

  _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Short term Bilateral",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFFEC908),
          ),
        ),
        SizedBox(height: 3),
        Text(
          "Choose to buy",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFFF6645A),
          ),
        ),
        SizedBox(height: 9),
        LayoutBuilder(builder: (context, constraints) {
          return Container(
            height: 104,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: Color(0xFFB4B4B4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Scrollbar(
              isAlwaysShown: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var item in widget.items)
                        _ListItem(item: item, forDate: widget.forDate),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _Summary(items: widget.items),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _SubmitButton(
            onSubmit: _onSubmit,
            onCancel: _onCancel,
          ),
        ),
      ],
    );
  }

  void _onCancel() {
    Navigator.of(context).pop(false);
  }

  void _onSubmit() {
    Navigator.of(context).pop(true);
  }
}

class _SubmitButton extends StatelessWidget {
  final Function()? onSubmit;
  final Function()? onCancel;
  const _SubmitButton({
    Key? key,
    this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFFFEC908),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: onSubmit,
          child: Text(
            'Agree',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFFC4C4C4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(0),
          ),
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  final List<BilateralBuyItem> items;

  const _Summary({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sumEstimateBuy =
        items.fold<double>(0, (sum, item) => sum + item.estimatedBuy);

    final netEnergyToBuy =
        items.fold<double>(0, (sum, item) => sum + item.energyToBuy);

    final averagePrice = sumEstimateBuy / netEnergyToBuy;

    return Column(
      children: [
        _SummaryItem(
          title: 'Estimated buy',
          value: sumEstimateBuy,
          unit: 'THB',
        ),
        SizedBox(height: 4),
        _SummaryItem(
          title: 'NET energy price',
          value: averagePrice,
          unit: 'THB',
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final double value;
  final String unit;

  const _SummaryItem({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 6,
          child: FittedBox(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  final BilateralBuyItem item;
  final DateTime forDate;

  const _ListItem({
    Key? key,
    required this.item,
    required this.forDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hourFormat = DateFormat("HH:mm");
    final dateFormat = DateFormat("dd MMM");

    final startHour =
        DateTime(forDate.year, forDate.month, forDate.day, forDate.hour);
    final endHour = startHour.add(Duration(hours: 1));

    final startHourString = hourFormat.format(startHour);
    final endHourString = hourFormat.format(endHour);
    final dateFormatString = dateFormat.format(forDate);

    final timeString = '$startHourString-$endHourString, $dateFormatString';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${item.name}, Energy ${item.energyToBuy} kWh',
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        Text(
          timeString,
          style: TextStyle(fontSize: 11, color: Colors.black),
        ),
      ],
    );
  }
}
