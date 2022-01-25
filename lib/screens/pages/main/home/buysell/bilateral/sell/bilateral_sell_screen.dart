import 'dart:async';
import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import '../apis/models/BilateralSellItem.dart';
import '../apis/bilateral_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'long_term/bilateral_long_term_sell_page.dart';
import 'short_term/bilateral_short_term_sell_page.dart';

class BilateralSellScreen extends StatefulWidget {
  final DateTime date;

  const BilateralSellScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  _BilateralSellScreenState createState() => _BilateralSellScreenState();
}

enum _OfferOrderType {
  PRICE,
  ENERGY,
}

enum _OfferOrderDirection {
  ASC,
  DESC,
}

class _OfferOrder {
  final _OfferOrderType type;
  final _OfferOrderDirection direction;

  const _OfferOrder(this.type, this.direction);

  operator ==(Object b) {
    if (b is _OfferOrder) {
      return type == b.type && direction == b.direction;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(type, direction);
}

class _BilateralSellScreenState extends State<BilateralSellScreen> {
  _OfferOrder _selectedOrder =
      const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.DESC);

  Set<BilateralSellItem> _selectedItems = Set();

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Sell"),
      body: SafeArea(
        child: FutureBuilder<List<BilateralSellItem>>(
          future: _getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return _buildBody(context, snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<BilateralSellItem> items) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildAction(context, items),
    );
  }

  Padding _buildAction(
    BuildContext context,
    List<BilateralSellItem> _bilateralItemList,
  ) {
    LoginSession loginModel = Provider.of<LoginSession>(context);

    final boughtItems = _bilateralItemList.where(
      (element) {
        var isSeller = element.sellerId == loginModel.info!.userId;
        var isBuyer = (element.buyerId ?? '') == loginModel.info!.userId;
        return isSeller || isBuyer;
      },
    );

    bool isSubmitable = boughtItems.length == 0;

    if (_selectedOrder.type == _OfferOrderType.PRICE) {
      _bilateralItemList.sort(
        (a, b) {
          if (_selectedOrder.direction == _OfferOrderDirection.ASC) {
            return a.price.compareTo(b.price);
          } else {
            return b.price.compareTo(a.price);
          }
        },
      );
    } else {
      _bilateralItemList.sort(
        (a, b) {
          if (_selectedOrder.direction == _OfferOrderDirection.ASC) {
            return a.energy.compareTo(b.energy);
          } else {
            return b.energy.compareTo(a.energy);
          }
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HeaderSection(),
                        _DateSection(date: widget.date),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 170,
                          child: _buildMap(context, _bilateralItemList),
                        ),
                        SizedBox(height: 12),
                        _SelectionSection(
                          selectedOrder: _selectedOrder,
                          onOrderChanged: (newOrder) => {
                            setState(() {
                              _selectedOrder = newOrder;
                            })
                          },
                        ),
                        Container(
                          height: constraints.maxHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: _bilateralItemList.length,
                            itemBuilder: (context, index) {
                              return Visibility(
                                visible: (_bilateralItemList[index].isLongterm)
                                    ? false
                                    : true,
                                child: _SellItemCard(
                                  index: index,
                                  item: _bilateralItemList[index],
                                  isChecked: _selectedItems.contains(
                                    _bilateralItemList[index],
                                  ),
                                  onTap: () => _onItemTap(
                                    _bilateralItemList[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              BottomButton(
                onAction: isSubmitable ? _onPlaceOrderPressed : null,
                actionLabel: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('trade-bilateral-placeOrder'),
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 13;

    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }

    zoomLevel = zoomLevel;
    return zoomLevel;
  }

  Widget _buildMap(BuildContext context, List<BilateralSellItem> items) {
    final markers = <Marker>[];
    for (final entry in items.asMap().entries) {
      final item = entry.value;
      final index = entry.key;

      markers.add(Marker(
        draggable: false,
        markerId: MarkerId(index.toString()),
        position: LatLng(item.lat, item.lng),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: _convertIndexToAlphabatical(index),
        ),
      ));
    }

    LatLng position = LatLng(15.87, 100.99);

    double zoomRadius = 2000000;
    if (items.length != 0) {
      double topLeftX = items.first.lng;
      double topLeftY = items.first.lat;
      double bottomRightX = items.first.lng;
      double bottomRightY = items.first.lat;

      for (final item in items) {
        if (item.lat > topLeftX) {
          topLeftX = item.lng;
        }

        if (item.lng > topLeftY) {
          topLeftY = item.lat;
        }

        if (item.lat > bottomRightX) {
          bottomRightX = item.lng;
        }

        if (item.lat < bottomRightY) {
          bottomRightY = item.lat;
        }
      }

      zoomRadius = max(topLeftX - bottomRightX, topLeftY - bottomRightY).abs();
      zoomRadius *= 200000;

      if (zoomRadius == 0) {
        zoomRadius = 200;
      }

      position = LatLng(
        (topLeftY + bottomRightY) / 2,
        (topLeftX + bottomRightX) / 2,
      );
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition:
          CameraPosition(target: position, zoom: getZoomLevel(zoomRadius)),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set<Marker>.of(markers),
    );
  }

  void _onPlaceOrderPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BilateralShortTermSellPage(
          requestItems: [
            TransactionSubmitItem(date: widget.date, amount: 1, price: 3)
          ],
        ),
      ),
    );

    Navigator.pop(context);
  }

  Future<List<BilateralSellItem>> _getData() async {
    final loginSession = Provider.of<LoginSession>(context, listen: false);

    if (loginSession.info == null) {
      showException(context, "No login session provided");
      throw Exception("No login session provided");
    }

    final accessToken = loginSession.info!.accessToken;

    var data = await bilateralApi.getBilateralShortTermSellInfo(
      requestDate: widget.date,
      accessToken: accessToken,
    );

    return data.bilateralList;
  }

  _onItemTap(BilateralSellItem sellItem) {
    setState(() {
      if (_selectedItems.contains(sellItem)) {
        _selectedItems.remove(sellItem);
      } else {
        _selectedItems.add(sellItem);
      }
    });
  }
}

class _SelectionSection extends StatelessWidget {
  final List<_OfferOrder> offerItems = const [
    const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.ASC),
    const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.DESC),
    const _OfferOrder(_OfferOrderType.ENERGY, _OfferOrderDirection.ASC),
    const _OfferOrder(_OfferOrderType.ENERGY, _OfferOrderDirection.DESC),
  ];

  final _OfferOrder selectedOrder;
  final Function(_OfferOrder)? onOrderChanged;

  const _SelectionSection({
    Key? key,
    required this.selectedOrder,
    this.onOrderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          height: 35,
          width: 120,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).translate('search'),
                    hintStyle: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: (String keyword) {},
                ),
              ),
              Icon(
                Icons.search,
                color: blackColor,
              )
            ],
          ),
        ),
        Row(
          children: [
            Text("${AppLocalizations.of(context).translate('sortBy')} : "),
            Container(
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<_OfferOrder>(
                value: selectedOrder,
                icon: Icon(Icons.arrow_drop_down_rounded),
                iconSize: 20,
                iconEnabledColor: backgroundColor,
                dropdownColor: primaryColor,
                style: TextStyle(fontSize: 16, color: backgroundColor),
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(20),
                onChanged: onOrderChanged != null
                    ? (_OfferOrder? newValue) {
                        if (newValue != null) {
                          onOrderChanged?.call(newValue);
                        }
                      }
                    : null,
                items: offerItems.map((_OfferOrder item) {
                  final direactionName;
                  switch (item.direction) {
                    case _OfferOrderDirection.ASC:
                      direactionName =
                          AppLocalizations.of(context).translate('lowest');
                      break;
                    case _OfferOrderDirection.DESC:
                      direactionName =
                          AppLocalizations.of(context).translate('highest');
                      break;
                  }

                  final propertyName;
                  switch (item.type) {
                    case _OfferOrderType.ENERGY:
                      propertyName =
                          AppLocalizations.of(context).translate('energy');
                      break;
                    case _OfferOrderType.PRICE:
                      propertyName =
                          AppLocalizations.of(context).translate('price');
                      break;
                  }

                  return DropdownMenuItem<_OfferOrder>(
                    value: item,
                    child: Text(
                      AppLocalizations.of(context).getLocale().toString() ==
                              "en"
                          ? "$direactionName $propertyName"
                          : "$propertyName$direactionName",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                underline: DropdownButtonHideUnderline(
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({Key? key}) : super(key: key);

  onLongTermPressed(BuildContext context) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => BilateralLongTermSellPage(),
      ),
    );

    if (result != null && result) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate('trade-bilateral-offerToSell-bilateral'),
                style: TextStyle(fontSize: 24, color: greenColor),
              ),
              Text(
                  AppLocalizations.of(context)
                      .translate('trade-bilateral-shortTermBilateral'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200)),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => onLongTermPressed(context),
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: AppLocalizations.of(context)
                          .translate('trade-bilateral-longtermBilateral'),
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(elevation: 0),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateSection extends StatelessWidget {
  const _DateSection({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat(
        'dd MMMM yyyy', AppLocalizations.of(context).getLocale().toString());
    var hourFormat = DateFormat('HH:mm');

    var startDate = date;
    var endDate = startDate.add(new Duration(hours: 1));

    var startDateStartHour = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startDate.hour,
    ).toLocal();
    var endDateStartHour = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endDate.hour,
    ).toLocal();

    var startHour = hourFormat.format(startDateStartHour);
    var endHour = hourFormat.format(endDateStartHour);

    String displayDate = "$startHour-$endHour, ${dateFormat.format(startDate)}";

    return Row(
      children: [
        RichText(
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          text: TextSpan(
            text: displayDate,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class _SellItemCard extends StatelessWidget {
  final BilateralSellItem item;
  final int index;
  final Function()? onTap;
  final bool isChecked;

  const _SellItemCard({
    Key? key,
    required this.item,
    required this.index,
    required this.isChecked,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat(
        'HH:mm, dd MMM', AppLocalizations.of(context).getLocale().toString());

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _convertIndexToAlphabatical(index),
                          style: TextStyle(color: blackColor),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: isChecked ? primaryColor : whiteColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dateFormat.format(
                            DateTime.parse(item.date).toLocal(),
                          ),
                          style: TextStyle(
                            color: isChecked ? primaryColor : whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 12,
                  thickness: 2,
                  color: greyColor,
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        item.energy.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: isChecked ? primaryColor : whiteColor,
                        ),
                      ),
                      Text(
                        "kWh",
                        style: TextStyle(
                          fontSize: 12,
                          color: isChecked ? primaryColor : whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 12,
                  thickness: 2,
                  color: greyColor,
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 24),
                  child: Column(
                    children: [
                      Text(
                        item.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 16,
                          color: isChecked ? primaryColor : whiteColor,
                        ),
                      ),
                      Text(
                        "THB",
                        style: TextStyle(
                          fontSize: 12,
                          color: isChecked ? primaryColor : whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _convertIndexToAlphabatical(int index) {
  if (index <= 0) {
    return '';
  }

  String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  return _convertIndexToAlphabatical(index ~/ 24) + alphabet[index % 24];
}
