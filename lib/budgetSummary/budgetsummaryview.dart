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

double budgetAmount = 0;
double overallExpenses = 0;
double remainingBalance = 0;

double calculateTotalExpenses(List<Transactions> transactions) {
  double totalExpenses = 0;
  for (var transaction in transactions) {
    totalExpenses += transaction.tranAmount;
  }
  return totalExpenses;
}

double calculateRemainingBalance(double totalBudget, double totalExpenses) {
  double remBalance = totalBudget - totalExpenses;
  return remBalance;
}

class _BudgetSummaryViewState extends State<BudgetSummaryView> {
  void _handleMenuSelection(String choice) {
    if (choice == 'Set Budget') {
      showDialog(
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
                  double amount = double.parse(totalBudgetController.text);
                  setState(() {
                    budgetAmount = amount;
                    remainingBalance = calculateRemainingBalance(
                        budgetAmount, overallExpenses);
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

  Widget budgetSummaryList() => Card(
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
                '$budgetAmount', // Use 0.0 as the default value
                style: txtBold2,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ('$remainingBalance'),
                        style: txtBold1,
                      ),
                      const Text('Remaining Balance'),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ('$overallExpenses'),
                        style: txtBold1,
                      ),
                      const Text('Overall Expenses'),
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
        body: Column(
      children: [
        budgetSummaryList(),
      ],
    ));
  }
}
