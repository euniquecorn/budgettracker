import 'package:budget_tracker/transactiondata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionDialog extends StatefulWidget {
  final Function(TransactionData) onTransactionAdded;

  AddTransactionDialog({required this.onTransactionAdded});

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
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
                          text:
                              DateFormat('MMMM dd, yyyy').format(selectedDate)),
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
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Category'),
          ),
          TextFormField(
            controller: amountController,
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
            String name = nameController.text;
            String category = categoryController.text;
            double amount = double.tryParse(amountController.text) ?? 0.0;

            final newTransaction = TransactionData(
              tranName: name,
              tranDate: DateFormat('MMMM dd, yyyy').format(selectedDate),
              tranCategory: category,
              tranAmount: amount,
            );

            //Print all the inputs
            // print('Transaction Data: $newTransaction');
            // print('Name: $name');
            // print('Date: ${DateFormat('MMMM dd, yyyy').format(selectedDate)}');
            // print('Category: $category');
            // print('Amount: $amount');

            widget.onTransactionAdded(newTransaction);
            // Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
