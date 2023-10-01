import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String transactionName;
  final String transactionCategory;
  final String transactionDate;
  final double transactionAmount;
  final Function() onTap; // Callback function to handle the tap

  const TransactionCard({
    Key? key,
    required this.transactionName,
    required this.transactionCategory,
    required this.transactionDate,
    required this.transactionAmount,
    required this.onTap, // Pass the onTap function as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Wrap the Card with InkWell
      onTap: onTap, // Call the onTap callback when tapped
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transactionName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                transactionCategory,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    transactionDate,
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Php ${transactionAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
