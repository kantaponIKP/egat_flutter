import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/state/trading_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:egat_flutter/constant.dart';
import 'package:provider/provider.dart';

class Tabbar extends StatefulWidget {
  Tabbar({Key? key}) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {

  @override
  Widget build(BuildContext context) {
    PageStatus model = Provider.of<PageStatus>(context);
    // TradingTabbar model = Provider.of<TradingTabbar>(context, listen: false);
    return Row(
      children: [
        Expanded(
          child: Stack(children: [
            Container(
              color: model.state == PageState.Forecast? primaryColor:greyColor,
              child: InkWell(
                onTap: () {
                  _onForecastTabPressed();
                },
                child: Container(
                  height: 32,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.home,
                                size: 18, color: model.state == PageState.Forecast? onPrimaryBgColor: whiteColor),
                          ),
                          TextSpan(
                              text: " Forecast",
                              style: TextStyle(color: model.state == PageState.Forecast? onPrimaryBgColor: whiteColor)),
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
                  strokeColor: model.state == PageState.BilateralTrade? primaryColor:greyColor,
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
              color: model.state == PageState.BilateralTrade? primaryColor:greyColor,
              child: InkWell(
                onTap: () {
                  _onBilateralTabPressed();
                },
                child: Container(
                  height: 32,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.handyman,
                                size: 18, color: model.state == PageState.BilateralTrade? onPrimaryBgColor: whiteColor),
                          ),
                          TextSpan(
                              text: " Bilateral",
                              style: TextStyle(color: model.state == PageState.BilateralTrade? onPrimaryBgColor: whiteColor)),
                          TextSpan(
                              text: "\nTrade",
                              style:
                                  TextStyle(color: model.state == PageState.BilateralTrade? onPrimaryBgColor: whiteColor, fontSize: 12)),
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
                  strokeColor: model.state == PageState.PoolMarketTrade? primaryColor:greyColor,
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
            color: model.state == PageState.PoolMarketTrade? primaryColor:greyColor,
            child: InkWell(
              onTap: () {
                _onPoolMarketTabPressed();
              },
              child: Container(
                height: 32,
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child:
                              Icon(Icons.refresh, size: 18, color: model.state == PageState.PoolMarketTrade? onPrimaryBgColor: whiteColor),
                        ),
                        TextSpan(
                          text: " Pool Market",
                          style: TextStyle(color: model.state == PageState.PoolMarketTrade? onPrimaryBgColor: whiteColor),
                        ),
                        TextSpan(
                          text: "\nTrade",
                          style: TextStyle(color: model.state == PageState.PoolMarketTrade? onPrimaryBgColor: whiteColor, fontSize: 12),
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


  void _onForecastTabPressed() {
    TradingTabbar tradingTabbar = Provider.of<TradingTabbar>(context, listen: false);
    tradingTabbar.setPageForecast();
  }

  void _onBilateralTabPressed() {
    TradingTabbar tradingTabbar = Provider.of<TradingTabbar>(context, listen: false);
    tradingTabbar.setPageBilateralTrade();
  }

  void _onPoolMarketTabPressed() {
    TradingTabbar tradingTabbar = Provider.of<TradingTabbar>(context, listen: false);
    tradingTabbar.setPagePoolMarketTrade();
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
