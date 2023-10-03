import 'package:budget_tracker/transactiondata.dart';
import 'package:budget_tracker/transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionData) onTransactionAdded;

  AddTransactionDialog({required this.onTransactionAdded});

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController tranName = TextEditingController();
  DateTime tranDate = DateTime.now();
  final TextEditingController tranAmount = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tranDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tranDate = picked;
      });
    }
  }

  Future createUser() async {
    final docUser = FirebaseFirestore.instance.collection('Transactions').doc();
    final newTransaction = Transactions(
      id: docUser.id,
      tranName: tranName.text,
      tranDate: tranDate,
      tranAmount: double.parse(tranAmount.text),
    );

    final json = newTransaction.toJson();
    await docUser.set(json);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: tranName,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                          text: DateFormat('MMMM dd, yyyy').format(tranDate)),
                      decoration: const InputDecoration(labelText: 'Date'),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _selectDate(context),
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
          TextFormField(
            controller: tranAmount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            createUser();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
