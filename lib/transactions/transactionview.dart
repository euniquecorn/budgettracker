import 'package:budget_tracker/budgetSummary/budgetsummaryview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budget_tracker/transactions/edittransaction.dart';
import 'package:budget_tracker/transactions/transactions.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key}) : super(key: key);

  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  Stream<List<Transactions>> readUsers() {
    return FirebaseFirestore.instance
        .collection('Transactions')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Transactions.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future deleteUser(String id) async {
    final docUser =
        FirebaseFirestore.instance.collection('Transactions').doc(id);
    docUser.delete();
  }

  void _showEditDialog(Transactions transactions) {
    showDialog(
      context: context,
      builder: (_) => EditTransactionDialog(
        transaction: transactions,
        onTransactionUpdated: (updatedTransaction) {
          // Handle updated transaction, e.g., update the UI or state
        },
      ),
    );
  }

  Widget transactionList(Transactions transactions) => InkWell(
        onTap: () {},
        child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black54,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transactions.tranName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String choice) {
                        if (choice == 'Edit') {
                          _showEditDialog(transactions);
                        } else if (choice == 'Delete') {
                          deleteUser(transactions.id);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM dd, yyyy').format(transactions.tranDate),
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Php ${transactions.tranAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Transactions>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final transactions = snapshot.data!;
            overallExpenses = calculateTotalExpenses(transactions);
            remainingBalance =
                calculateRemainingBalance(budgetAmount, overallExpenses);

            print('Overall Expenses $overallExpenses');
            print('Remaining Balance $remainingBalance');
            print('Total Budget $budgetAmount');
            return ListView(
              children: transactions.map(transactionList).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
