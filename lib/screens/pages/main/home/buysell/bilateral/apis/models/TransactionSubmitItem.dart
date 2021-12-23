class TransactionSubmitItem {
  final DateTime date;
  final double amount;
  final double price;

  TransactionSubmitItem({
    required this.date,
    required this.amount,
    required this.price,
  });

  toJson() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'price': price,
    };
  }
}
