import 'package:budget_tracker/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String tranName;
  final String tranDate;
  final double tranAmount;

  Transactions({
    required this.tranName,
    required this.tranDate,
    required this.tranAmount,
  });

  static Transactions fromJson(Map<String, dynamic> json) => Transactions(
        tranName: json['tranName'],
        tranDate: (json['tranDate'] as Timestamp).toDate().toString(),
        tranAmount: double.tryParse(json['tranAmount'].toString()) ?? 0.0,
      );
}
