import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {
  final String id;
  final String tranName;
  final DateTime tranDate;
  final double tranAmount;

  Transactions({
    required this.id,
    required this.tranName,
    required this.tranDate,
    required this.tranAmount,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      id: json['id'],
      tranName: json['tranName'],
      tranDate: (json['tranDate'] as Timestamp).toDate(),
      tranAmount: double.tryParse(json['tranAmount'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tranName': tranName,
        'tranDate': Timestamp.fromDate(tranDate),
        'tranAmount': tranAmount,
      };
}
