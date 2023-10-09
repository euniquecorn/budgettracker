import 'package:budget_tracker/budgetSummary/budgetsummary.dart';
import 'package:budget_tracker/transactions/transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BudgetSummaryView extends StatefulWidget {
  const BudgetSummaryView({Key? key}) : super(key: key);

  @override
  State<BudgetSummaryView> createState() => _BudgetSummaryViewState();
}

TextEditingController totalBudgetController = TextEditingController();

const TextStyle txtBold1 = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
const TextStyle txtBold2 = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.bold,
);
const TextStyle txtBold3 = TextStyle(
  fontSize: 17,
  letterSpacing: 1,
);
const TextStyle txtBold4 = TextStyle(
  fontSize: 17,
  letterSpacing: 1,
  fontWeight: FontWeight.bold,
);
const TextStyle txtBold5 = TextStyle(
  fontSize: 17,
);

double overallExpenses = 0.0;
double remainingBalance = 0.0;

Stream<List<BudgetSummary>> readUsers() {
  return FirebaseFirestore.instance.collection('Transactions').snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => BudgetSummary.fromJson(
                doc.data(),
              ),
            )
            .toList(),
      );
}

Future createUser() async {
  final docUser = FirebaseFirestore.instance.collection('BudgetSummary').doc();
  final newBudget = BudgetSummary(
    id: docUser.id,
    balance: remainingBalance,
    overallExpenses: overallExpenses,
    totalBudget: double.parse(totalBudgetController.text),
  );
}

double calculateTotalExpenses(List<Transactions> transactions) {
  double totalExpenses = 0.0;
  for (var transaction in transactions) {
    totalExpenses += transaction.tranAmount;
  }
  return totalExpenses;
}

double calculateRemainingBalance(double totalBudget, double totalExpenses) {
  return totalBudget - totalExpenses;
}

class _BudgetSummaryViewState extends State<BudgetSummaryView> {
  late double totalBudget = 0.0;
  late double overallExpenses = 0.0;
  late double remainingBalance = 0.0;

  Future<void> _handleMenuSelection(String choice) async {
    if (choice == 'Set Budget') {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Set Budget'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: totalBudgetController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Enter Budget Amount'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    totalBudget = double.parse(totalBudgetController.text);
                    // Save the totalBudget to your database if needed
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget budgetSummaryList(BudgetSummary budgetSummary) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Budget',
                    style: txtBold3,
                  ),
                  PopupMenuButton<String>(
                    onSelected: _handleMenuSelection,
                    itemBuilder: (BuildContext context) {
                      return ['Set Budget'].map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              Text(
                (totalBudget).toStringAsFixed(2),
                style: txtBold2,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (remainingBalance).toStringAsFixed(2),
                        style: txtBold1,
                      ),
                      const Text('Remaining Balance'),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (overallExpenses).toStringAsFixed(2),
                        style: txtBold1,
                      ),
                      const Text('Total Expenses'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<BudgetSummary>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final budgetSumm = snapshot.data!;
            return ListView(
              children: budgetSumm.map(budgetSummaryList).toList(),
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
