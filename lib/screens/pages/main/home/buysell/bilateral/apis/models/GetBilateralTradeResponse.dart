import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/models/bilateral_model.dart';

class GetBilateralTradeResponse {
  final List<BilateralTradeItemModel> _items;
  List<BilateralTradeItemModel> get items => _items;

  const GetBilateralTradeResponse({
    required List<BilateralTradeItemModel> items,
  }) : _items = items;

  GetBilateralTradeResponse.fromJSON(
    List<dynamic> jsonList,
  ) : _items = [] {
    for (var item in jsonList) {
      _items
          .add(BilateralTradeItemModel.fromJSON(item as Map<String, dynamic>));
    }
  }
}
