import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';

class Tapbar extends StatelessWidget {
  Tapbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(children: [
            Container(
              color: primaryColor,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 32,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.home,
                                size: 18, color: onPrimaryBgColor),
                          ),
                          TextSpan(
                              text: " Forecast",
                              style: TextStyle(color: onPrimaryBgColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: greyColor,
                  strokeWidth: 10,
                  paintingStyle: PaintingStyle.fill,
                ),
                child: Container(
                  height: 32,
                  width: 10,
                ),
              ),
            ),
          ]),
        ),
        Expanded(
          child: Stack(children: [
            Container(
              color: greyColor,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 32,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.handyman,
                                size: 18, color: whiteColor),
                          ),
                          TextSpan(
                              text: " Bilateral",
                              style: TextStyle(color: whiteColor)),
                          TextSpan(
                              text: "\nTrade",
                              style:
                                  TextStyle(color: whiteColor, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: CustomPaint(
                painter: TrianglePainter(
                  strokeColor: greyColor,
                  strokeWidth: 10,
                  paintingStyle: PaintingStyle.fill,
                ),
                child: Container(
                  height: 32,
                  width: 10,
                ),
              ),
            ),
          ]),
        ),
        Expanded(
          child: Container(
            color: greyColor,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 32,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child:
                              Icon(Icons.refresh, size: 18, color: whiteColor),
                        ),
                        TextSpan(
                          text: " Pool Market",
                          style: TextStyle(color: whiteColor),
                        ),
                        TextSpan(
                          text: "\nTrade",
                          style: TextStyle(color: whiteColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    Paint paint2 = Paint()
      ..color = backgroundColor
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(-size.width, size.height / 2), paint2);
    canvas.drawLine(Offset(-size.width, size.height / 2),
        Offset(size.width, size.height), paint2);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(x, 0)
      ..lineTo(-x, y / 2)
      ..lineTo(x, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
