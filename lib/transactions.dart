import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String tranName;
  final DateTime tranDate;
  final double tranAmount;

  Transactions({
    required this.tranName,
    required this.tranDate,
    required this.tranAmount,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      tranName: json['tranName'],
      tranDate: (json['tranDate'] as Timestamp).toDate(),
      tranAmount: double.tryParse(json['tranAmount'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'tranName': tranName,
        'tranDate':
            Timestamp.fromDate(tranDate), // Convert DateTime to Timestamp
        'tranAmount': tranAmount,
      };
}
