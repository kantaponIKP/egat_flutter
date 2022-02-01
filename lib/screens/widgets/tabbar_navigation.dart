import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';
import 'package:flutter_svg/svg.dart';

class TabBarNavigationItem<T> {
  final String title;
  final String? secondaryTitle;
  final IconData? icon;
  final String? svgIcon;
  final T value;

  const TabBarNavigationItem({
    required this.title,
    required this.value,
    this.icon,
    this.secondaryTitle,
    this.svgIcon,
  });

  Widget buildIcon(
    BuildContext context, {
    bool isSelected = false,
  }) {
    if (svgIcon != null) {
      return SvgPicture.asset(
        svgIcon!,
        fit: BoxFit.contain,
        height: 18,
        color: isSelected ? onPrimaryBgColor : whiteColor,
      );
    }

    if (icon != null) {
      return Icon(
        icon,
        size: 18,
        color: isSelected ? onPrimaryBgColor : whiteColor,
      );
    }

    throw new Exception('Icon and svgIcon is null');
  }
}

class TabBarNavigation<T> extends StatelessWidget {
  final List<TabBarNavigationItem<T>> items;
  final T value;

  final Function(T)? onTap;

  const TabBarNavigation({
    required this.items,
    required this.onTap,
    required this.value,
    Key? key,
  }) : super(key: key);

  void _onPressed(TabBarNavigationItem item) {
    if (onTap != null) {
      onTap!(item.value);
    }
  }

  Widget _buildItem(
    BuildContext context, {
    required TabBarNavigationItem item,
    bool isSelected = false,
    bool isLast = false,
    bool isFollowedBySelectedItem = false,
  }) {
    var titles = <TextSpan>[
      TextSpan(
        text: "${item.title}",
        style: TextStyle(
          color: isSelected ? onPrimaryBgColor : whiteColor,
        ),
      ),
    ];

    if (item.secondaryTitle != null && item.secondaryTitle!.length > 0) {
      titles.add(
        TextSpan(
          text: "\n${item.secondaryTitle}",
          style: TextStyle(
            color: isSelected ? onPrimaryBgColor : whiteColor,
            fontSize: 12,
          ),
        ),
      );
    }

    final widgets = <Widget>[
      Expanded(
        child: Container(
          color: isSelected ? primaryColor : greyColor,
          child: InkWell(
            onTap: () {
              _onPressed(item);
            },
            child: Container(
              height: 32,
              child: Center(
                child: LayoutBuilder(builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          item.buildIcon(context, isSelected: isSelected),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                children: [
                                  ...titles,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      )
    ];

    if (!isLast) {
      widgets.add(
        CustomPaint(
          painter: _TrianglePainter(
            fillLeft: isSelected,
            fillRight: isFollowedBySelectedItem,
            fillColor: primaryColor,
            emptyColor: greyColor,
          ),
          child: Container(
            height: 32,
            width: 20,
          ),
        ),
      );
    }

    return Expanded(
      child: Row(
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var itemEntry in items.asMap().entries)
          _buildItem(
            context,
            item: itemEntry.value,
            isFollowedBySelectedItem: (items.length > itemEntry.key + 1)
                ? items[itemEntry.key + 1].value == value
                : false,
            isSelected: itemEntry.value.value == value,
            isLast: itemEntry.key == items.length - 1,
          ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final bool fillLeft;
  final bool fillRight;
  final Color fillColor;
  final Color emptyColor;

  final int strokeHalfWidth;

  const _TrianglePainter({
    required this.fillLeft,
    required this.fillRight,
    required this.fillColor,
    required this.emptyColor,
    this.strokeHalfWidth = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paintLeft(canvas, size);
    _paintRight(canvas, size);
  }

  void _paintRight(Canvas canvas, Size size) {
    Paint paintRight = Paint()
      ..color = fillRight ? fillColor : emptyColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      _getRightTrianglePath(size.width, size.height),
      paintRight,
    );
  }

  void _paintLeft(Canvas canvas, Size size) {
    Paint paintLeft = Paint()
      ..color = fillLeft ? fillColor : emptyColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      _getLeftTrianglePathBottom(size.width, size.height),
      paintLeft,
    );

    canvas.drawPath(
      _getLeftTrianglePathTop(size.width, size.height),
      paintLeft,
    );
  }

  Path _getRightTrianglePath(double x, double y) {
    return Path()
      ..moveTo(x, y)
      ..lineTo(strokeHalfWidth.toDouble(), y / 2)
      ..lineTo(x, 0);
  }

  Path _getLeftTrianglePathTop(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x - strokeHalfWidth, 0)
      ..lineTo(0, y / 2);
  }

  Path _getLeftTrianglePathBottom(double x, double y) {
    return Path()
      ..moveTo(x - strokeHalfWidth, y)
      ..lineTo(0, y)
      ..lineTo(0, y / 2);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) {
    return oldDelegate.fillLeft != fillLeft ||
        oldDelegate.fillRight != fillRight ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.emptyColor != emptyColor;
  }
}
