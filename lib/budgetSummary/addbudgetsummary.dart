import 'package:budget_tracker/budgetSummary/budgetsummary.dart';
import 'package:flutter/material.dart';

class EditBudgetSummaryDialog extends StatefulWidget {
  final BudgetSummary budgetSummary;

  EditBudgetSummaryDialog({required this.budgetSummary});

  @override
  _EditBudgetSummaryDialogState createState() =>
      _EditBudgetSummaryDialogState();
}

class _EditBudgetSummaryDialogState extends State<EditBudgetSummaryDialog> {
  late TextEditingController totalBudgetController;
  late TextEditingController overallExpensesController;
  late TextEditingController balanceController;

  @override
  void initState() {
    super.initState();
    totalBudgetController = TextEditingController(
        text: widget.budgetSummary.totalBudget.toString());
    overallExpensesController = TextEditingController(
        text: widget.budgetSummary.overallExpenses.toString());
    balanceController =
        TextEditingController(text: widget.budgetSummary.balance.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Budget Summary'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: totalBudgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Total Budget'),
          ),
          TextFormField(
            controller: overallExpensesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Overall Expenses'),
          ),
          TextFormField(
            controller: balanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Balance'),
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
            // Handle updating the budget summary here
            double totalBudget = double.parse(totalBudgetController.text);
            double overallExpenses =
                double.parse(overallExpensesController.text);
            double balance = double.parse(balanceController.text);

            BudgetSummary updatedSummary = BudgetSummary(
              id: widget.budgetSummary.id,
              totalBudget: totalBudget,
              overallExpenses: overallExpenses,
              balance: balance,
            );

            // Call a function to update the budget summary in your database or state
            // updateBudgetSummary(updatedSummary);

            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
