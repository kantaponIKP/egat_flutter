import 'dart:collection';

import 'package:flutter/cupertino.dart';

class BuySellActionController extends ChangeNotifier {
  var _buySellInfoMaps = <String, BuySellInfo>{};
  get buySellInfoMaps => UnmodifiableMapView(_buySellInfoMaps);

  BuySellAction? _currentAction;

  List<BuySellInfo> get buySellInfos => _buySellInfoMaps.values.toList();
  bool get isAllSelected {
    if (_currentAction == null) {
      return _buySellInfoMaps.length > 0 &&
          _buySellInfoMaps.values.every((info) => info.isSelected);
    } else {
      return _buySellInfoMaps.length > 0 &&
          _buySellInfoMaps.values.every(
              (info) => info.isSelected || info.action != _currentAction);
    }
  }

  bool get isNoneSelected =>
      _buySellInfoMaps.values.every((info) => !info.isSelected);

  void clearInfos() {
    _buySellInfoMaps.clear();
    notifyListeners();
  }

  BuySellInfo? getBuySellInfoAtDateTime(DateTime dateTime) {
    final dateStartHour = DateTime(
        dateTime.year, dateTime.month, dateTime.day, dateTime.hour, 0, 0);

    final dateKey = dateStartHour.toIso8601String();

    return _buySellInfoMaps[dateKey];
  }

  void removeOptions({
    required BuySellInfo buySellInfo,
  }) {
    _buySellInfoMaps.removeWhere((key, value) => value.key == buySellInfo.key);
    notifyListeners();
  }

  void updateOptions({
    required DateTime dateTime,
    required BuySellAction action,
    required double expectingAmount,
    required bool isSelected,
    required UniqueKey uniqueKey,
    bool notify = true,
  }) {
    final dateStartHour = DateTime(
        dateTime.year, dateTime.month, dateTime.day, dateTime.hour, 0, 0);

    final dateKey = dateStartHour.toIso8601String();

    var buySellInfo = _buySellInfoMaps[dateKey];
    if (buySellInfo == null) {
      return;
    }

    if (buySellInfo.key != uniqueKey) {
      return;
    }

    var isSelectable = true;
    if (_buySellInfoMaps[dateKey] != null) {
      isSelectable = _buySellInfoMaps[dateKey]!.isSelectable;
    }

    var isSelectedCheck = isSelected;
    if (_buySellInfoMaps[dateKey] != null &&
        !_buySellInfoMaps[dateKey]!.isSelectable) {
      isSelectedCheck = false;
    }
    isSelectedCheck = isSelectedCheck && isSelectable;

    _buySellInfoMaps[dateKey] = buySellInfo.copyWith(
      action: action,
      dateTime: dateTime,
      expectingAmount: expectingAmount,
      isSelected: isSelectedCheck,
      isSelectable: isSelectable,
    );

    if (isSelectedCheck) {
      _currentAction = action;

      var keys = _buySellInfoMaps.keys.toList();
      for (var key in keys) {
        if (buySellInfoMaps[key]!.action != action) {
          _buySellInfoMaps[key] = _buySellInfoMaps[key]!
              .copyWith(isSelected: false, isSelectable: false);
        }
      }
    } else if (isNoneSelected) {
      _currentAction = null;

      var keys = _buySellInfoMaps.keys.toList();
      for (var key in keys) {
        _buySellInfoMaps[key] =
            _buySellInfoMaps[key]!.copyWith(isSelectable: true);
      }
    }

    if (notify) {
      notifyListeners();
    }
  }

  BuySellInfo addOptions({
    required DateTime dateTime,
    required BuySellAction action,
    required double expectingAmount,
  }) {
    final dateStartHour = DateTime(
        dateTime.year, dateTime.month, dateTime.day, dateTime.hour, 0, 0);

    final dateKey = dateStartHour.toIso8601String();

    var isSelectable = true;
    if (_buySellInfoMaps[dateKey] != null) {
      isSelectable = _buySellInfoMaps[dateKey]!.isSelectable;
    }

    _buySellInfoMaps[dateKey] = BuySellInfo(
      action: action,
      dateTime: dateTime,
      expectingAmount: expectingAmount,
      isSelected: false,
      isSelectable: isSelectable,
    );

    return _buySellInfoMaps[dateKey]!;
  }

  void selectAll({
    BuySellAction? action,
  }) {
    if (_buySellInfoMaps.length == 0) {
      return;
    }

    _currentAction = action ?? _buySellInfoMaps.values.first.action;

    var keys = _buySellInfoMaps.keys.toList();
    for (var key in keys) {
      if (_currentAction != null &&
          _buySellInfoMaps[key]!.action != _currentAction) {
        _buySellInfoMaps[key] = _buySellInfoMaps[key]
            ?.copyWith(isSelected: false, isSelectable: false);
      } else {
        _buySellInfoMaps[key] = _buySellInfoMaps[key]
            ?.copyWith(isSelected: true, isSelectable: true);
      }
    }
    notifyListeners();
  }

  void deselectAll() {
    if (_buySellInfoMaps.length == 0) {
      return;
    }

    var keys = _buySellInfoMaps.keys.toList();
    for (var key in keys) {
      _buySellInfoMaps[key] = _buySellInfoMaps[key]
          ?.copyWith(isSelected: false, isSelectable: true);
    }
    notifyListeners();
  }

  void clearOptions() {
    _buySellInfoMaps.clear();
    notifyListeners();
  }
}

enum BuySellAction {
  BUY,
  SELL,
}

class BuySellInfo {
  final BuySellAction action;
  final double expectingAmount;
  final DateTime dateTime;
  final bool isSelected;
  final bool isSelectable;

  late UniqueKey _key;
  UniqueKey get key => _key;

  BuySellInfo({
    required this.action,
    required this.expectingAmount,
    required this.dateTime,
    required this.isSelected,
    required this.isSelectable,
    UniqueKey? key,
  }) {
    this._key = key ?? UniqueKey();
  }

  copyWith({
    BuySellAction? action,
    double? expectingAmount,
    DateTime? dateTime,
    bool? isSelected,
    bool? isSelectable,
  }) {
    return BuySellInfo(
      action: action ?? this.action,
      expectingAmount: expectingAmount ?? this.expectingAmount,
      dateTime: dateTime ?? this.dateTime,
      isSelected: isSelected ?? this.isSelected,
      isSelectable: isSelectable ?? this.isSelectable,
      key: this.key,
    );
  }
}
