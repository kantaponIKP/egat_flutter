import 'package:egat_flutter/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../controllers/transaction_item_controller.dart';

class SellLongTermConfirmationDialog extends StatefulWidget {
  final List<TransactionSubmitItem> items;

  SellLongTermConfirmationDialog({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  _SellLongTermConfirmationDialogState createState() =>
      _SellLongTermConfirmationDialogState();
}

class _ListItem extends StatelessWidget {
  final TransactionSubmitItem item;

  const _ListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hourFormat = DateFormat("HH:mm");

    final forDate = item.date;
    final startHour =
        DateTime(forDate.year, forDate.month, forDate.day, forDate.hour);
    final endHour = startHour.add(Duration(hours: 1));

    final startHourString = hourFormat.format(startHour);
    final endHourString = hourFormat.format(endHour);

    final timeString = '$startHourString-$endHourString';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            '$timeString price ${item.price} THB/kWh, for ${item.duration} kWh',
            style: TextStyle(fontSize: 12, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _SellLongTermConfirmationDialogState
    extends State<SellLongTermConfirmationDialog> {
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

  @override
  void initState() {
    super.initState();
  }

  _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Long term Bilateral",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFFEC908),
          ),
        ),
        SizedBox(height: 3),
        Text(
          "Offer to sell everyday",
          style: TextStyle(
            fontSize: 15,
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
                      for (var item in widget.items) _ListItem(item: item),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
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
