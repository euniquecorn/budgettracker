import 'transactiondata.dart';

class TransactionList {
  List<TransactionData> itemList = [
    TransactionData(
      tranName: 'Grocery',
      tranDate: 'September 1 2023',
      tranCategory: 'Allowance',
      tranAmount: 500.00,
    ),
    TransactionData(
      tranName: 'Examination Fee',
      tranDate: 'September 2 2023',
      tranCategory: 'School Fee',
      tranAmount: 3000.00,
    )
  ];

  void add(TransactionData transaction) {
    itemList.add(transaction);
  }
}
