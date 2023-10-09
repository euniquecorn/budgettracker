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

  static BudgetSummary fromJson(Map<String, dynamic> json) {
    return BudgetSummary(
      id: json['id'] ?? '',
      balance: (json['balance'] as double?) ?? 0.0,
      overallExpenses: (json['overallExpenses'] as double?) ?? 0.0,
      totalBudget: (json['totalBudget'] as double?) ?? 0.0,
    );
  }

  Future<void> createUser({
    required String tranName,
    required DateTime tranDate,
    required double tranAmount,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('Transactions').doc();
    final newTransaction = Transactions(
      id: docUser.id,
      tranName: tranName,
      tranDate: tranDate,
      tranAmount: tranAmount,
    );

    final json = newTransaction.toJson();
    await docUser.set(json);
  }

  Future<void> createUserBudget(double totalBudget) async {
    try {
      String newId =
          FirebaseFirestore.instance.collection('BudgetSummary').doc().id;
      await FirebaseFirestore.instance
          .collection('BudgetSummary')
          .doc(newId)
          .set({
        'id': newId,
        'totalBudget': totalBudget,
        'balance': totalBudget, // Initial balance equals total budget
        'overallExpenses': 0.0, // Initial overall expenses is 0
      });
    } catch (e) {
      print('Error creating user budget: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }
}
