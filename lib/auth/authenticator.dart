import 'package:budget_tracker/homepage.dart';
import 'package:budget_tracker/auth/login.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Authenticator extends StatefulWidget {
  const Authenticator({super.key});

  @override
  State<Authenticator> createState() => _AuthenticatorState();
}

class _AuthenticatorState extends State<Authenticator> {
  @override
  Widget build(BuildContext context) {
    var tabs = const [
      GButton(
        icon: Icons.account_circle,
        text: 'Profile',
      ),
      GButton(
        icon: Icons.home,
        text: 'Home',
      ),
      GButton(
        icon: Icons.logout,
        text: 'Logout',
      ),
    ];

    return Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return const HomePage();
            } else {
              return const Login();
            }
          },
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
                tabs: tabs),
          ),
        ));
  }
}
