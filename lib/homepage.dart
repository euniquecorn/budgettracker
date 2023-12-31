import 'package:budget_tracker/auth/login.dart';
import 'package:budget_tracker/budgetSummary/budgetsummaryview.dart';
import 'package:budget_tracker/transactions/addtransaction.dart';
import 'package:budget_tracker/transactions/transactionview.dart';
import 'package:budget_tracker/user/userProfile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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

  var tabs = const [
    GButton(
      icon: Icons.home,
      text: 'Home',
    ),
    GButton(
      icon: Icons.account_circle,
      text: 'Profile',
    ),
    GButton(
      icon: Icons.logout,
      text: 'Logout',
    ),
  ];

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
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 250,
                child: BudgetSummaryView(),
              ),
              Divider(thickness: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Transactions',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TransactionView(),
              ),
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
        bottomNavigationBar: Container(
          color: Colors.deepPurple.shade300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GNav(
                backgroundColor: Colors.deepPurple.shade300,
                color: Colors.white,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.all(15),
                gap: 8,
                onTabChange: (index) async {
                  switch (index) {
                    case 0:
                      print('Home: ');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                      break;

                    case 1:
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const UserProfilePage(),
                      ));
                      break;

                    case 2:
                      print('Logout ');
                      try {
                        await FirebaseAuth.instance.signOut();
                        print('User signed out successfully');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              const Login(), // Redirect to the login page
                        ));
                      } catch (e) {
                        print('Error signing out: $e');
                      }
                      break;
                  }
                },
                tabs: tabs),
          ),
        ));
  }
}
