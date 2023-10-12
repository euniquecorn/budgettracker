import 'package:budget_tracker/budgetSummary/budgetsummaryview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:budget_tracker/transactions/transactions.dart';

class BudgetSummary {
  final String id;
  final double balance;
  final double overallExpenses;
  double totalBudget;

  BudgetSummary({
    required this.id,
    required this.balance,
    required this.overallExpenses,
    required this.totalBudget,
  });
}
