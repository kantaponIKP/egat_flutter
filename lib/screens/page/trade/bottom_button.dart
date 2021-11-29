import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomButton extends StatelessWidget {
  final Function()? onAction;
  final Widget actionLabel;

  const BottomButton({
    this.onAction,
    required this.actionLabel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    return _buildActionButtonNext();
  }

  Widget _buildActionButtonNext() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onAction, // null return disabled
          child: Row(
            children: [
              Spacer(),
              actionLabel,
              Spacer(),
            ],
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
