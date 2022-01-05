import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/BilateralBuyItem.dart';
import 'package:flutter/cupertino.dart';

class BuyItemController extends ChangeNotifier {
  Map<Object, BilateralBuyItem> _items = {};

  Map<Object, BilateralBuyItem> get items => _items;

  void addItem(Object owner, BilateralBuyItem item) {
    // In case we switch to the checkbox,
    // Just remove this line
    _items.clear();

    _items.putIfAbsent(owner, () => item);
    notifyListeners();
  }

  void removeItem(Object owner) {
    _items.remove(owner);
    notifyListeners();
  }

  bool isOwnerSelected(Object owner) {
    return _items.containsKey(owner);
  }
}
