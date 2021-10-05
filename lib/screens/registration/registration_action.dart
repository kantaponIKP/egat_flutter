import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum RegistrationActionDirection { Next, Back }

class RegistrationAction extends StatelessWidget {
  final Function()? onAction;
  final Widget actionLabel;
  final RegistrationActionDirection direction;

  const RegistrationAction({
    this.onAction,
    required this.actionLabel,
    this.direction = RegistrationActionDirection.Next,
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
    return SizedBox(
      child: ElevatedButton(
        onPressed: onAction, // null return disabled
        child: Row(
          children: [
            Spacer(),
            actionLabel,
            Spacer(),
          ],
        ),
        style: ElevatedButton.styleFrom(elevation: 0,),
      ),
    );
  }
}
