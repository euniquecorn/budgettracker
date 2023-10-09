import 'package:budget_tracker/budgetSummary/budgetsummaryview.dart';
import 'package:budget_tracker/login.dart';
import 'package:budget_tracker/transactions/addtransaction.dart';
import 'package:budget_tracker/transactions/transactionview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 171, 235),
        title: const Text('Budget Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 250,
              child: BudgetSummaryView(),
            ),
            const Divider(thickness: 2),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Transactions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TransactionView(),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      print('User signed out successfully');
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Login(), // Redirect to the login page
                      ));
                    } catch (e) {
                      print('Error signing out: $e');
                    }
                  },
                  child: const Text('SIGN OUT'),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a dialog/form to add a new transaction
          showDialog(
            context: context,
            builder: (_) => AddTransactionDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
