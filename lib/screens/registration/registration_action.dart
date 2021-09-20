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
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        children: [
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    if (direction == RegistrationActionDirection.Next) {
      return _buildActionButtonNext();
    }

    return _buildActionButtonBack();
  }

  Widget _buildActionButtonBack() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onAction,
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 16,
                  ),
                ),
              ),
            ),
            actionLabel,
            Spacer(flex: 1),
          ],
        ),
        style: ElevatedButton.styleFrom(elevation: 0),
      ),
    );
  }

  Widget _buildActionButtonNext() {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onAction,
        child: Row(
          children: [
            Spacer(),
            actionLabel,
            Spacer(),
          ],
        ),
        style: ElevatedButton.styleFrom(elevation: 0),
      ),
    );
  }
}
