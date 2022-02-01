import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/widgets/forgot_password_cancellation_dialog.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/buy/controller/buy_item_controller.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/buy/dialogs/buy_confirmation_dialog.dart';
import '../apis/models/BilateralBuyItem.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import '../apis/bilateral_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import 'long_term/long_term_buy_page.dart';
import 'short_term/bilateral_short_term_sell_page.dart';

class BilateralBuyScreen extends StatefulWidget {
  final DateTime date;
  final bool enabled;

  const BilateralBuyScreen({
    Key? key,
    required this.date,
    required this.enabled,
  }) : super(key: key);

  @override
  _BilateralBuyScreenState createState() => _BilateralBuyScreenState();
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

class _BilateralBuyScreenState extends State<BilateralBuyScreen> {
  _OfferOrder _selectedOrder =
      const _OfferOrder(_OfferOrderType.PRICE, _OfferOrderDirection.DESC);

  Set<BilateralBuyItem> _selectedItems = Set();

  Completer<GoogleMapController> _controller = Completer();

  BuyItemController _buyItemController = BuyItemController();

  bool _isAtLeastOneItemSelected = false;

  @override
  void initState() {
    super.initState();
    _getData();

    _buyItemController = BuyItemController();
    _isAtLeastOneItemSelected = false;

    _buyItemController.addListener(_onSelectedItemChanged);
  }

  void _onSelectedItemChanged() {
    setState(() {
      _isAtLeastOneItemSelected = _buyItemController.items.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _buyItemController.removeListener(_onSelectedItemChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Buy"),
      body: SafeArea(
        child: FutureBuilder<List<BilateralBuyItem>>(
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

  Widget _buildBody(BuildContext context, List<BilateralBuyItem> items) {
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
    List<BilateralBuyItem> _bilateralItemList,
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
            return a.energyPrice.compareTo(b.energyPrice);
          } else {
            return b.energyPrice.compareTo(a.energyPrice);
          }
        },
      );
    } else {
      _bilateralItemList.sort(
        (a, b) {
          if (_selectedOrder.direction == _OfferOrderDirection.ASC) {
            return a.netEnergyPrice.compareTo(b.netEnergyPrice);
          } else {
            return b.netEnergyPrice.compareTo(a.netEnergyPrice);
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
                                child: _BuyItem(
                                  item: _bilateralItemList[index],
                                  controller: _buyItemController,
                                  key: Key('item-$index'),
                                  index: index,
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
                onAction:
                    isSubmitable && _isAtLeastOneItemSelected && widget.enabled
                        ? _onPlaceOrderPressed
                        : null,
                actionLabel: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).translate('submit'),
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

  Future<BitmapDescriptor> createCustomMarkerWithAlphabets(
      String alphabets) async {
    TextSpan span = new TextSpan(
        style: new TextStyle(
          height: 1.2,
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
        ),
        text: alphabets);

    TextPainter textPainter = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 20, maxWidth: 20);

    PictureRecorder recorder = new PictureRecorder();
    Canvas canvas = new Canvas(recorder);

    Paint pinPaint = new Paint()..color = Color(0xFFFEC908);

    canvas.drawCircle(Offset(10, 10), 10, pinPaint);
    textPainter.paint(canvas, Offset(0, 2));

    Picture picture = recorder.endRecording();
    ByteData? pngBytes = await (await picture.toImage(30, 30))
        .toByteData(format: ImageByteFormat.png);

    if (pngBytes == null) {
      return BitmapDescriptor.defaultMarker;
    }

    return BitmapDescriptor.fromBytes(pngBytes.buffer.asUint8List());
  }

  List<BitmapDescriptor> _markers = <BitmapDescriptor>[];

  _prepareMarkers(int length) async {
    List<Future<BitmapDescriptor>> markerFutures = <Future<BitmapDescriptor>>[];

    for (var i = 0; i < length; i++) {
      final alphabets = _convertIndexToAlphabatical(i);
      markerFutures.add(createCustomMarkerWithAlphabets(alphabets));
    }

    _markers = await Future.wait(markerFutures);
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

  Widget _buildMap(BuildContext context, List<BilateralBuyItem> items) {
    final markers = <Marker>[];
    for (final entry in items.asMap().entries) {
      final item = entry.value;
      final index = entry.key;

      markers.add(
        Marker(
          draggable: false,
          markerId: MarkerId(index.toString()),
          position: LatLng(item.lat, item.lng),
          icon: _markers.length > index
              ? _markers[index]
              : BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: _convertIndexToAlphabatical(index),
          ),
        ),
      );
    }

    LatLng position = LatLng(15.87, 100.99);

    double zoomRadius = 2000000;
    if (items.length != 0) {
      double topLeftX = items.first.lng;
      double topLeftY = items.first.lat;
      double bottomRightX = items.first.lng;
      double bottomRightY = items.first.lat;

      for (final item in items) {
        if (item.lat > topLeftY) {
          topLeftY = item.lat;
        }

        if (item.lng > topLeftX) {
          topLeftX = item.lng;
        }

        if (item.lat > bottomRightY) {
          bottomRightY = item.lat;
        }

        if (item.lat < bottomRightX) {
          bottomRightX = item.lng;
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
    final items = _buyItemController.items.values.toList();

    final dialogAnswer = await showDialog<bool>(
      context: context,
      builder: (context) {
        return BuyConfirmationDialog(
          items: items,
          forDate: widget.date,
        );
      },
    );

    if (dialogAnswer == true) {
      _placeOrder(items[0]);
    }
  }

  Future<List<BilateralBuyItem>> _getData() async {
    final loginSession = Provider.of<LoginSession>(context, listen: false);

    if (loginSession.info == null) {
      showException(context, "No login session provided");
      throw Exception("No login session provided");
    }

    final accessToken = loginSession.info!.accessToken;

    var data = await bilateralApi.getBilateralShortTermBuyInfo(
      requestDate: widget.date,
      accessToken: accessToken,
    );

    await _prepareMarkers(data.bilateralList.length);

    return data.bilateralList;
  }

  _onItemTap(BilateralBuyItem buyItem) {
    setState(() {
      if (_selectedItems.contains(buyItem)) {
        _selectedItems.remove(buyItem);
      } else {
        _selectedItems.add(buyItem);
      }
    });
  }

  void _placeOrder(BilateralBuyItem item) async {
    showLoading();
    try {
      final loginSession = Provider.of<LoginSession>(context, listen: false);

      if (loginSession.info == null) {
        showException(context, "No login session provided");
        throw Exception("No login session provided");
      }

      final accessToken = loginSession.info!.accessToken;

      await bilateralApi.bilateralShortTermBuy(
        id: item.id,
        accessToken: accessToken,
      );
      Navigator.of(context).pop();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
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
            Text("Sort by : "),
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
        builder: (context) => LongTermBuyPage(),
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
                    .translate('trade-bilateral-chooseToBuy-buy'),
                style: TextStyle(fontSize: 24, color: redColor),
              ),
              Text(
                AppLocalizations.of(context)
                    .translate('trade-bilateral-shortTermBilateral'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
              ),
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
    var dateFormat = intl.DateFormat(
      'dd MMMM yyyy',
      AppLocalizations.of(context).getLocale().toString(),
    );
    var hourFormat = intl.DateFormat('HH:mm');

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

String _convertIndexToAlphabatical(int index) {
  String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  if (index ~/ 24 > 0) {
    return _convertIndexToAlphabatical(index ~/ 24) + alphabet[index % 24];
  } else {
    return alphabet[index % 24];
  }
}

class _BuyItem extends StatefulWidget {
  final BilateralBuyItem item;
  final BuyItemController controller;
  final int index;

  const _BuyItem({
    Key? key,
    required this.item,
    required this.controller,
    required this.index,
  }) : super(key: key);

  @override
  __BuyItemState createState() => __BuyItemState();
}

class __BuyItemState extends State<_BuyItem> {
  bool _selected = false;
  bool _expanded = true;

  Object get _key => this.widget.key ?? this;

  @override
  void initState() {
    super.initState();

    _selected = false;
    _expanded = true;

    widget.controller.addListener(_selectedListener);
  }

  void _selectedListener() {
    setState(() {
      _selected = widget.controller.isOwnerSelected(_key);
    });
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_selectedListener);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF3E3E3E),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            _BuyItemHeader(
              item: widget.item,
              selected: widget.item.buyerId != null || _selected,
              expanded: _expanded,
              index: widget.index,
              onChanged: widget.item.buyerId == null ? _onChange : null,
              onExpand: _onExpand,
            ),
            _BuyItemBody(
              item: widget.item,
              selected: _selected,
              expanded: _expanded,
            ),
          ],
        ),
      ),
    );
  }

  void _onChange(bool newState) {
    if (newState) {
      widget.controller.addItem(_key, widget.item);
    } else {
      widget.controller.removeItem(_key);
    }
  }

  void _onExpand(bool p1) {
    setState(() {
      _expanded = !_expanded;
    });
  }
}

class _BuyItemHeader extends StatelessWidget {
  final BilateralBuyItem item;
  final bool selected;
  final bool expanded;
  final int index;

  final void Function(bool)? onChanged;
  final void Function(bool)? onExpand;

  const _BuyItemHeader({
    Key? key,
    required this.item,
    required this.selected,
    required this.expanded,
    required this.index,
    this.onChanged,
    this.onExpand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = intl.DateFormat(
      'HH:mm, dd MMM',
      AppLocalizations.of(context).getLocale().toString(),
    );
    final createDateString = dateFormat.format(item.date);

    return GestureDetector(
      onTap: onExpand != null
          ? () {
              if (onChanged != null) {
                onExpand?.call(!selected);
              }
            }
          : null,
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: selected,
            onChanged: onChanged != null
                ? (newValue) {
                    if (newValue != null) {
                      onChanged?.call(newValue);
                    }
                  }
                : null,
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return IntrinsicHeight(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, right: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFEC908),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    width: 17,
                                    height: 17,
                                    child: Center(
                                      child: Text(
                                        _convertIndexToAlphabatical(index),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    item.name,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Text(createDateString,
                                    style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "${item.energyToBuy.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "kWh",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                            VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "${AppLocalizations.of(context).translate('trade-estimatedBuy')} ${item.estimatedBuy.toStringAsFixed(2)} THB",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    "${AppLocalizations.of(context).translate('trade-netEnergyPrice')} ${item.netEnergyPrice.toStringAsFixed(2)} THB/kWh",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: Duration(milliseconds: 150),
            child: const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }
}

class _BuyItemBody extends StatelessWidget {
  final BilateralBuyItem item;
  final bool selected;
  final bool expanded;

  const _BuyItemBody({
    Key? key,
    required this.item,
    required this.selected,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 150),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: expanded ? double.infinity : 0,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          child: Column(
            children: [
              _BuyItemDetail(
                title:
                    AppLocalizations.of(context).translate('trade-energyToBuy'),
                value: item.energyToBuy,
                unit: 'kWh',
                fontSize: 15,
              ),
              _BuyItemDetail(
                title: AppLocalizations.of(context)
                    .translate('trade-energyTariff'),
                value: item.energyTariff,
                unit: 'THB/kWh',
                fontSize: 12,
              ),
              _BuyItemDetail(
                title:
                    AppLocalizations.of(context).translate('trade-energyPrice'),
                value: item.energyPrice,
                unit: 'THB',
                fontSize: 15,
              ),
              _BuyItemDetail(
                title: AppLocalizations.of(context)
                    .translate('trade-wheelingChargeTariff'),
                value: item.wheelingChargeTariff,
                unit: 'THB/kWh',
                fontSize: 12,
              ),
              _BuyItemDetail(
                title: AppLocalizations.of(context)
                    .translate('trade-wheelingCharge'),
                value: item.wheelingCharge,
                unit: 'THB',
                fontSize: 15,
              ),
              _BuyItemDetail(
                title:
                    AppLocalizations.of(context).translate('trade-tradingFee'),
                value: item.energyToBuy,
                unit: 'THB',
                fontSize: 12,
              ),
              _BuyItemDetail(
                title: AppLocalizations.of(context).translate('trade-vat'),
                value: item.vat,
                unit: 'THB',
                fontSize: 12,
              ),
              _BuyItemDetail(
                title: AppLocalizations.of(context)
                    .translate('trade-estimatedBuy'),
                value: item.estimatedBuy,
                unit: 'THB',
                fontSize: 15,
              ),
              _BuyItemDetail(
                title: AppLocalizations.of(context)
                    .translate('trade-netEstimatedEnergyPrice'),
                value: item.netEnergyPrice,
                unit: 'THB',
                fontSize: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyItemDetail extends StatelessWidget {
  final String title;
  final double value;
  final String unit;

  final double fontSize;

  const _BuyItemDetail({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    this.fontSize = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(title, style: TextStyle(fontSize: fontSize)),
        ),
        Text(
          "${value.toStringAsFixed(2)} $unit",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
