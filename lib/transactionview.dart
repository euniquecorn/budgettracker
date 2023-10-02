import 'package:budget_tracker/transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  Stream<List<Transactions>> readUsers() {
    return FirebaseFirestore.instance
        .collection('Transactions')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              // type the snapshot object using map method
              .map(
                // call the fromJson function that was created from the  Employee class.
                (doc) => Transactions.fromJson(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Widget transactionList(Transactions transactions) => InkWell(
        onTap: () {},
        child: Card(
          elevation: 2,
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.black54,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transactions.tranName,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM dd, yyyy').format(transactions.tranDate),
                      // Format DateTime as a String using DateFormat
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Php ${transactions.tranAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Transactions>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final transactions = snapshot.data!;
            return ListView(
                children: transactions.map(transactionList).toList());
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
