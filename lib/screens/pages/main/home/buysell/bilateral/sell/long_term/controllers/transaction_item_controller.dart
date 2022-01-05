import 'dart:collection';

import 'package:flutter/widgets.dart';

class TransactionItemController<T> extends ChangeNotifier {
  Map<Object, T> _selectedItemMap = {};
  Map<Object, T> get selectedItemMap => UnmodifiableMapView(_selectedItemMap);

  List<T> get selectedItems =>
      UnmodifiableListView(_selectedItemMap.values.toList());

  void selectItem(
    Object owner,
    T item, {
    bool notify = true,
  }) {
    _selectedItemMap[owner] = item;

    if (notify) {
      notifyListeners();
    }
  }

  void deselectItem(Object owner) {
    _selectedItemMap.remove(owner);
    notifyListeners();
  }

  bool isItemSelected(Object owner) {
    return _selectedItemMap.containsKey(owner);
  }
}

class TransactionSubmitItem {
  final DateTime date;
  final double amount;
  final double price;
  final int duration;

  TransactionSubmitItem({
    required this.date,
    required this.amount,
    required this.price,
    required this.duration,
  });

  toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'price': price,
      'duration': duration,
    };
  }
}
