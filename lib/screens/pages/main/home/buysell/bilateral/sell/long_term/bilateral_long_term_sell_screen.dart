import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/bilateral_api.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/BilateralLongTermSellInfoResponse.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/BilateralLongTermSellRequest.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/pin_input_blocker.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'controllers/transaction_item_controller.dart';
import 'dialogs/sell_longterm_confirmation_dialog.dart';

class BilateralLongTermSellScreen extends StatefulWidget {
  BilateralLongTermSellScreen({Key? key}) : super(key: key);

  @override
  _BilateralLongTermSellScreenState createState() =>
      _BilateralLongTermSellScreenState();
}

class _BilateralLongTermSellScreenState
    extends State<BilateralLongTermSellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Long Term", secondTitle: "Bilateral"),
      body: SafeArea(
        child: FutureBuilder<List<BilateralLongtermSellInfo>>(
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

  Widget _buildBody(
      BuildContext context, List<BilateralLongtermSellInfo> items) {
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

  Widget _buildAction(
    BuildContext context,
    List<BilateralLongtermSellInfo> _bilateralItemList,
  ) {
    return _Body(bilateralItemList: _bilateralItemList);
  }

  Future<List<BilateralLongtermSellInfo>> _getData() async {
    final loginSession = Provider.of<LoginSession>(context);

    if (loginSession.info == null) {
      logger.log(Level.debug, 'loginSession.info is null');
      throw Exception('LoginSession is not provided.');
    }

    final now = DateTime.now();
    final nextStartHour = DateTime(now.year, now.month, now.day, now.hour + 4);

    var response = await bilateralApi.getBilateralLongTermSellInfo(
      date: nextStartHour,
      accessToken: loginSession.info!.accessToken,
    );

    return response.bilateralList;
  }
}

class _Body extends StatefulWidget {
  final List<BilateralLongtermSellInfo> bilateralItemList;

  const _Body({
    Key? key,
    required this.bilateralItemList,
  }) : super(key: key);

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  TransactionItemController<TransactionSubmitItem> _controller =
      TransactionItemController();

  @override
  void initState() {
    super.initState();

    _controller = TransactionItemController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context).translate('trade-bilateral-period'), style: TextStyle(fontSize: 15)),
                Text(AppLocalizations.of(context).translate('everyday'), style: TextStyle(fontSize: 13)),
                SizedBox(height: 16),
                Expanded(
                  child: _TransactionList(
                    controller: _controller,
                    items: widget.bilateralItemList,
                  ),
                ),
                SizedBox(height: 8),
                _SubmitButton(
                  controller: _controller,
                  onPressed: _onSubmit,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _onSubmit() async {
    var promptResult = await showDialog<bool>(
      context: context,
      builder: (context) {
        return SellLongTermConfirmationDialog(
          items: _controller.selectedItems,
        );
      },
    );
    if (promptResult == null || promptResult == false) {
      return;
    }

    bool? isPassed = await PinInputBlocker.pushTo(context);
    if (isPassed != true) {
      showException(context, 'PIN is required!');
      return;
    }

    showLoading();
    try {
      final loginSession = Provider.of<LoginSession>(context, listen: false);

      if (loginSession.info == null) {
        logger.log(Level.debug, 'loginSession.info is null');
        throw Exception('LoginSession is not provided.');
      }

      await bilateralApi.bilateralLongTermSell(
        accessToken: loginSession.info!.accessToken,
        submitItems: _controller.selectedItems
            .map<BilateralLongtermSellItem>(
              (item) => BilateralLongtermSellItem(
                days: item.duration,
                price: item.price,
                energy: item.amount,
                time: item.date,
              ),
            )
            .toList(),
      );
      showSuccessSnackBar(context, 'Success');
      Navigator.of(context).pop(true);
    } catch (e) {
      showException(context, e.toString());
      Navigator.of(context).pop(false);
    } finally {
      hideLoading();
    }
  }
}

class _SubmitButton extends StatefulWidget {
  final Function()? onPressed;
  final TransactionItemController<TransactionSubmitItem> controller;

  _SubmitButton({
    Key? key,
    this.onPressed,
    required this.controller,
  }) : super(key: key);

  @override
  __SubmitButtonState createState() => __SubmitButtonState();
}

class __SubmitButtonState extends State<_SubmitButton> {
  bool isDisabled = true;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onItemChange);
    _updateIsDisabled();
  }

  void _onItemChange() {
    setState(() {
      _updateIsDisabled();
    });
  }

  void _updateIsDisabled() {
    isDisabled = widget.controller.selectedItems.isEmpty ||
        widget.controller.selectedItems.any(
          (element) {
            return element.amount == 0 || element.price == 0;
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: 48,
        child: ElevatedButton(
          onPressed: isDisabled ? null : widget.onPressed,
          child: Text(
            AppLocalizations.of(context)
                    .translate('submit'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      );
    });
  }
}

class _TransactionInput extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final String unit;
  final Function(double)? onChanged;
  final bool disabled;

  final TextEditingController? controller;

  const _TransactionInput({
    Key? key,
    required this.title,
    this.secondaryTitle,
    required this.unit,
    this.onChanged,
    this.controller,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    if (secondaryTitle != null) {
      titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          Text(
            secondaryTitle!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(title);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleWidget,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 80,
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    enabled: !disabled,
                    onChanged: (value) {
                      if (onChanged != null) {
                        onChanged?.call(double.tryParse(value) ?? 0);
                      }
                    },
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: primaryColor,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0.00',
                      contentPadding:
                          const EdgeInsets.only(right: 4, bottom: 4),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid value';
                      }

                      num? parsedValue = num.tryParse(value);

                      if (parsedValue == null) {
                        return 'Please enter a valid value';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 90,
                    ),
                    child: Text(unit),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TransactionDropDownInput<T> extends StatelessWidget {
  final String title;
  final String? secondaryTitle;
  final T value;
  final List<T> options;
  final String unit;
  final bool disabled;

  final Function(T)? onChanged;

  final TextEditingController? controller;

  const _TransactionDropDownInput({
    Key? key,
    required this.title,
    this.secondaryTitle,
    required this.value,
    required this.options,
    required this.unit,
    this.onChanged,
    this.controller,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWidget;
    if (secondaryTitle != null) {
      titleWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          Text(
            secondaryTitle!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      );
    } else {
      titleWidget = Text(title);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
      child: DefaultTextStyle(
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            titleWidget,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Color(0xFFFEC908),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: !disabled ? Color(0xFFFEC908) : greyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                      child: DropdownButton<T>(
                        isDense: true,
                        itemHeight: 50,
                        underline: SizedBox(),
                        value: value,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                        items: options.map((option) {
                          return DropdownMenuItem<T>(
                            value: option,
                            child: Text(
                              "${option.toString()} $unit",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: !disabled
                            ? (value) {
                                if (onChanged != null && value != null) {
                                  onChanged?.call(value);
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatefulWidget {
  final DateTime date;
  final bool defaultIsSelected;
  final bool defaultIsExpanded;

  final bool disabled;

  final double defaultEnergyToSale;
  final double defaultOfferToSellPrice;
  final List<int> dayOptions;
  final int? selectedDuration;

  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;

  final TransactionItemController<TransactionSubmitItem> controller;

  const _TransactionItem({
    required Key? key,
    required this.date,
    this.defaultIsSelected = false,
    this.defaultEnergyToSale = 0,
    this.defaultOfferToSellPrice = 0,
    this.defaultIsExpanded = false,
    required this.controller,
    this.disabled = false,
    required this.dayOptions,
    this.selectedDuration,
    this.selectedStartDate,
    this.selectedEndDate,
  }) : super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<_TransactionItem> {
  bool _isExpanded = true;

  double _energyToSale = 0;
  double _offerToSellPrice = 0;
  int _duration = 0;

  TextEditingController? energyToSaleTextController;

  TextEditingController? offerToSalePriceTextController;

  Object get _ownerKey => widget.key ?? this;

  TransactionSubmitItem get _submitItem => TransactionSubmitItem(
        amount: _energyToSale,
        price: _offerToSellPrice,
        date: widget.date,
        duration: _duration,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF292929),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: switchExpandedState,
              behavior: HitTestBehavior.translucent,
              child: _buildHeader(),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 150),
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                height: _isExpanded ? null : 0,
                child: _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_onControllerChange);
    energyToSaleTextController?.removeListener(_onTextEnergyToSaleChange);
    offerToSalePriceTextController
        ?.removeListener(_onTextOfferToSellPriceChanged);
  }

  @override
  void initState() {
    super.initState();

    _energyToSale = widget.defaultEnergyToSale;
    _offerToSellPrice = widget.defaultOfferToSellPrice;
    _isExpanded = widget.defaultIsExpanded;

    if (widget.defaultIsSelected) {
      widget.controller.selectItem(_ownerKey, _submitItem, notify: false);
    }

    energyToSaleTextController = TextEditingController(
      text: _energyToSale.toStringAsFixed(2),
    );
    energyToSaleTextController?.addListener(_onTextEnergyToSaleChange);

    offerToSalePriceTextController = TextEditingController(
      text: _offerToSellPrice.toStringAsFixed(2),
    );
    offerToSalePriceTextController?.addListener(_onTextOfferToSellPriceChanged);

    widget.controller.addListener(_onControllerChange);

    _duration = widget.dayOptions.length != 0 ? widget.dayOptions.first : 0;
  }

  void switchExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void switchSelectedState() {
    if (widget.disabled) {
      return;
    }

    final isSelected = widget.controller.isItemSelected(_ownerKey);

    if (!isSelected) {
      widget.controller.selectItem(_ownerKey, _submitItem);
    } else {
      widget.controller.deselectItem(_ownerKey);
    }
  }

  _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _TransactionDropDownInput(
          title: AppLocalizations.of(context).translate('trade-longterm-days'),
          options: widget.selectedDuration == null
              ? widget.dayOptions
              : [widget.selectedDuration!],
          unit: AppLocalizations.of(context).translate('days'),
          value: widget.selectedDuration == null
              ? _duration
              : widget.selectedDuration!,
          onChanged: _onDurationChange,
          disabled: widget.disabled,
        ),
        _TransactionInput(
          title: AppLocalizations.of(context).translate('trade-bilateral-energyToSale'),
          unit: 'kWh',
          controller: energyToSaleTextController,
          disabled: widget.disabled,
        ),
        SizedBox(height: 16),
        _TransactionSliderInput(
          unit: 'kWh',
          value: _energyToSale,
          onChange: _onEnergyToSalesSliderChange,
          disabled: widget.disabled,
        ),
        _TransactionInput(
          title: AppLocalizations.of(context).translate('trade-offerToSellPrice'),
          secondaryTitle: '${AppLocalizations.of(context).translate('trade-marketPrice')} = THB 3.00',
          unit: 'THB/kWh',
          controller: offerToSalePriceTextController,
          disabled: widget.disabled,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader() {
    final isSelected = widget.controller.isItemSelected(widget.key ?? this);

    final timeFormat = DateFormat('HH:mm');

    final widgetTime = widget.date.toLocal();

    final startTime = DateTime(
      widgetTime.year,
      widgetTime.month,
      widgetTime.day,
      widgetTime.hour,
    );
    final endTime = startTime.add(const Duration(hours: 1));

    final startTimeString = timeFormat.format(startTime);
    final endTimeString = timeFormat.format(endTime);

    var headerString = '$startTimeString-$endTimeString';

    if (widget.selectedDuration != null) {
      final dateFormat = DateFormat('dd MMM');
      final startDateString = dateFormat.format(widget.selectedStartDate!);
      final endDateString = dateFormat.format(widget.selectedEndDate!);

      headerString = '$headerString, $startDateString - $endDateString';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                activeColor: !widget.disabled ? primaryColor : Colors.grey,
                value: !widget.disabled ? isSelected : true,
                onChanged: (_) {
                  if (!widget.disabled) {
                    switchSelectedState();
                  }
                },
              ),
              Text(
                headerString,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          AnimatedRotation(
            duration: Duration(milliseconds: 150),
            turns: _isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  void _notifyChangeToController() {
    if (widget.disabled) {
      return;
    }

    if (widget.controller.isItemSelected(_ownerKey)) {
      widget.controller.selectItem(_ownerKey, _submitItem);
    }
  }

  _onControllerChange() {
    if (widget.disabled) {
      return;
    }

    try {
      setState(() {
        widget.controller.isItemSelected(_ownerKey);
      });
    } catch (e) {
      print(e);
    }
  }

  void _onEnergyToSalesSliderChange(double value) {
    if (widget.disabled) {
      return;
    }

    _energyToSale = value;

    if (energyToSaleTextController != null) {
      energyToSaleTextController!.value = TextEditingValue(
        text: _energyToSale.toStringAsFixed(2),
      );
    }

    _notifyChangeToController();
  }

  _onTextEnergyToSaleChange() {
    if (widget.disabled) {
      return;
    }

    final value = double.tryParse(energyToSaleTextController!.value.text);

    if (value != null) {
      setState(() {
        _energyToSale = value;
        _notifyChangeToController();
      });
    }
  }

  _onTextOfferToSellPriceChanged() {
    if (widget.disabled) {
      return;
    }

    final value = double.tryParse(offerToSalePriceTextController!.value.text);

    if (value != null) {
      setState(() {
        _offerToSellPrice = value;
        _notifyChangeToController();
      });
    }
  }

  _onDurationChange(int duration) {
    if (widget.disabled) {
      return;
    }

    setState(() {
      _duration = duration;
      _notifyChangeToController();
    });
  }
}

class _TransactionList extends StatelessWidget {
  final TransactionItemController<TransactionSubmitItem> controller;
  final List<BilateralLongtermSellInfo> items;

  const _TransactionList({
    Key? key,
    required this.controller,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            for (var item in items.asMap().entries)
              _TransactionItem(
                key: Key('transaction-item-${item.key}'),
                date: item.value.time,
                defaultIsSelected: false,
                disabled: item.value.startDate != null,
                defaultEnergyToSale: item.value.energy ?? 0,
                defaultOfferToSellPrice: item.value.price ?? 0,
                controller: controller,
                dayOptions: item.value.dayOptions,
                selectedDuration: item.value.days,
                selectedStartDate: item.value.startDate,
                selectedEndDate: item.value.endDate,
              ),
          ],
        ),
      ),
    );
  }
}

class _TransactionSliderInput extends StatelessWidget {
  final String unit;
  final double value;

  final void Function(double value)? onChange;
  final bool disabled;

  const _TransactionSliderInput({
    Key? key,
    required this.unit,
    required this.value,
    this.onChange,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = max(min(this.value, 10), 0);

    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Positioned(
            left: 16,
            top: 0,
            child: Center(
              child: Text(
                '0 $unit',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            child: Center(
              child: Text(
                '10 $unit',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbColor: primaryColor,
              activeTrackColor: primaryColor,
              inactiveTrackColor: primaryColor,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
              trackHeight: 2,
              valueIndicatorColor: primaryColor,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 10,
              divisions: 200,
              onChanged: !disabled ? onChange : null,
              label: '${value.toStringAsFixed(2)} $unit',
            ),
          ),
        ],
      ),
    );
  }
}
