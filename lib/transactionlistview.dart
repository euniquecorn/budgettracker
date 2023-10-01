import 'package:budget_tracker/transactioncard.dart';
import 'package:budget_tracker/transactiondata.dart';
import 'package:flutter/material.dart';

class TransactionListView extends StatelessWidget {
  final List<TransactionData> transactionList;

  const TransactionListView({Key? key, required this.transactionList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) {
        final transaction = transactionList[index];

        return TransactionCard(
          transactionName: transaction.tranName,
          transactionCategory: transaction.tranCategory,
          transactionDate: transaction.tranDate,
          transactionAmount: transaction.tranAmount,
          onTap: () {},
        );
      },
    );
  }
}
