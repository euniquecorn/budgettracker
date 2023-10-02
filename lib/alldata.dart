import 'package:budget_tracker/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  // Stream function that fetches data from the firestore collection.

  Stream<List<Users>> readUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map(
          (snapshot) => snapshot.docs
              // type the snapshot object using map method
              .map(
                // call the fromJson function that was created from the  Employee class.
                (doc) => Users.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Firebase User'),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
