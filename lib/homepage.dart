import 'package:budget_tracker/addtransaction.dart';
import 'package:budget_tracker/transactiondata.dart';
import 'package:budget_tracker/transactionlist.dart';
import 'package:budget_tracker/transactionlistview.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TransactionList transactionList = TransactionList();
  final TextStyle txtBold1 =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  final TextStyle txtBold2 = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  final TextStyle txtBold3 = const TextStyle(
    fontSize: 17,
    letterSpacing: 2,
  );
  final TextStyle txtBold4 = const TextStyle(
    fontSize: 17,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
  );
  final TextStyle txtBold5 = const TextStyle(
    fontSize: 17,
  );

  double totalBudget = 22000.00;
  void _addTransaction(TransactionData newTransaction) {
    setState(() {
      transactionList.itemList.add(newTransaction);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // Calculate total Expenses
  double _calculateTotalExpenses() {
    double totalExpenses = 0;
    for (var transaction in transactionList.itemList) {
      totalExpenses += transaction.tranAmount;
    }
    return totalExpenses;
  }

  double _calculateBalance() {
    return totalBudget - _calculateTotalExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 171, 235),
        title: const Text('Budget Tracker'),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PHP ${_calculateBalance().toStringAsFixed(2)}', // Use the calculated balance
                    style: txtBold2,
                  ),
                  Text(
                    'Balance',
                    style: txtBold3,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHP ${_calculateTotalExpenses().toStringAsFixed(2)}', // Use the calculated total expenses
                            style: txtBold1,
                          ),
                          const Text('Total Expenses'),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHP ${totalBudget.toStringAsFixed(2)}',
                            style: txtBold1,
                          ),
                          const Text('Total Budget'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(thickness: 2),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Expanded(
            child:
                TransactionListView(transactionList: transactionList.itemList),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a dialog/form to add a new transaction
          showDialog(
            context: context,
            builder: (_) => AddTransactionDialog(
              onTransactionAdded: (transactionData) {
                _addTransaction(transactionData);
                Navigator.of(context).pop();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
