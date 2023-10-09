import 'package:budget_tracker/transactions/transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTransactionDialog extends StatefulWidget {
  final Transactions transaction;
  final Function(Transactions) onTransactionUpdated;

  EditTransactionDialog({
    required this.transaction,
    required this.onTransactionUpdated,
  });

  @override
  _EditTransactionDialogState createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  late TextEditingController _tranNameController;
  late DateTime _tranDate;
  late TextEditingController _tranAmountController;

  @override
  void initState() {
    super.initState();
    _tranNameController =
        TextEditingController(text: widget.transaction.tranName);
    _tranDate = widget.transaction.tranDate;
    _tranAmountController =
        TextEditingController(text: widget.transaction.tranAmount.toString());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tranDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _tranDate = picked;
      });
    }
  }

  Future<void> _updateTransaction() async {
    final updatedTransaction = Transactions(
      id: widget.transaction.id,
      tranName: _tranNameController.text,
      tranDate: _tranDate,
      tranAmount: double.parse(_tranAmountController.text),
    );

    try {
      await FirebaseFirestore.instance
          .collection('Transactions')
          .doc(updatedTransaction.id)
          .update(updatedTransaction.toJson());

      // Call the callback to handle UI updates
      widget.onTransactionUpdated(updatedTransaction);
    } catch (e) {
      print('Error updating transaction: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _tranNameController,
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
                          text: DateFormat('MMMM dd, yyyy').format(_tranDate)),
                      decoration: const InputDecoration(labelText: 'Date'),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
              ),
            ],
          ),
          TextFormField(
            controller: _tranAmountController,
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
            _updateTransaction();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
