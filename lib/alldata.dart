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

  Widget buildList(Users users) => ListTile(
        leading: const Icon(Icons.person),
        title: Text(users.name),
        subtitle: Text(users.email),
        dense: true,
        onTap: () {},
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<List<Users>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView(children: users.map(buildList).toList());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
