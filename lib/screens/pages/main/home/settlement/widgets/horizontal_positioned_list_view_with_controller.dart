import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HorizontalPositionedListViewWithController extends StatefulWidget {
  final double controllerWidth;
  final List<Widget> children;

  const HorizontalPositionedListViewWithController({
    required this.children,
    this.controllerWidth = 40,
    Key? key,
  }) : super(key: key);

  @override
  _HorizontalPositionedListViewWithControllerState createState() =>
      _HorizontalPositionedListViewWithControllerState();
}

enum _ChangeDirection {
  Left,
  Right,
  None,
}

class _HorizontalPositionedListViewWithControllerState
    extends State<HorizontalPositionedListViewWithController> {
  int currentIndex = 0;
  _ChangeDirection _changeDirection = _ChangeDirection.None;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LeftController(
          width: widget.controllerWidth,
          onTap: _onLeftTap,
          enabled: currentIndex > 0,
        ),
        Expanded(
          child: widget.children.length > currentIndex
              ? _Display(
                  child: widget.children[currentIndex],
                  childKey: Key('child-$currentIndex'),
                  changeDirection: _changeDirection,
                )
              : Container(
                  width: 200,
                  height: 300,
                ),
        ),
        _RightController(
          width: widget.controllerWidth,
          onTap: _onRightTap,
          enabled: currentIndex < widget.children.length - 1,
        ),
      ],
    );
  }

  _onLeftTap() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        _changeDirection = _ChangeDirection.Left;
      }
    });
  }

  _onRightTap() {
    setState(() {
      if (currentIndex < widget.children.length - 1) {
        currentIndex++;
        _changeDirection = _ChangeDirection.Right;
      }
    });
  }
}

class _Display extends StatelessWidget {
  final Widget child;
  final _ChangeDirection changeDirection;
  final Key? childKey;

  const _Display({
    Key? key,
    this.childKey,
    required this.child,
    this.changeDirection = _ChangeDirection.None,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 150),
        child: Container(
          key: childKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 250,
            ),
            child: child,
          ),
          width: constraints.maxWidth,
        ),
        transitionBuilder: buildSlideTransition,
      );
    });
  }

  Widget buildSlideTransition(Widget child, Animation<double> animation) {
    Offset begin;
    Offset end;

    if (changeDirection == _ChangeDirection.Left) {
      if (child.key == childKey) {
        begin = Offset(-1.5, 0);
        end = Offset(0, 0);
      } else {
        begin = Offset(1.5, 0);
        end = Offset(0, 0);
      }
    } else if (changeDirection == _ChangeDirection.Right) {
      if (child.key == childKey) {
        begin = Offset(1.5, 0);
        end = Offset(0, 0);
      } else {
        begin = Offset(-1.5, 0);
        end = Offset(0, 0);
      }
    } else {
      begin = Offset(0, 0);
      end = Offset(0, 0);
    }

    const curve = Curves.linear;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

class _LeftController extends StatelessWidget {
  final double width;
  final Function()? onTap;
  final bool enabled;

  const _LeftController({
    required this.width,
    required this.onTap,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Row(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: width,
              child: enabled ? Icon(Icons.chevron_left) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _RightController extends StatelessWidget {
  final double width;
  final Function()? onTap;
  final bool enabled;

  const _RightController({
    required this.width,
    required this.onTap,
    required this.enabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: width,
          child: enabled ? Icon(Icons.chevron_right) : null,
        ),
      ),
    );
  }
}
