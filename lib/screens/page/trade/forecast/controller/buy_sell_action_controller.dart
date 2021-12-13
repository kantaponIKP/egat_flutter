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

  void addOrUpdateOptions({
    required DateTime dateTime,
    required BuySellAction action,
    required double expectingAmount,
    required bool isSelected,
    bool notify = true,
  }) {
    if (_currentAction != null && _currentAction != action) {
      return;
    }

    final dateStartHour = DateTime(
        dateTime.year, dateTime.month, dateTime.day, dateTime.hour, 0, 0);

    final dateKey = dateStartHour.toIso8601String();

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

    _buySellInfoMaps[dateKey] = BuySellInfo(
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

  const BuySellInfo({
    required this.action,
    required this.expectingAmount,
    required this.dateTime,
    required this.isSelected,
    required this.isSelectable,
  });

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
    );
  }
}
