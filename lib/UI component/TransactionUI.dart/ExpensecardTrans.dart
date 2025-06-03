import 'package:flutter/material.dart';

class ExpensecardTrans extends StatelessWidget {
  final String category;
  final String amount;
  final String date;

  const ExpensecardTrans({
    super.key,
    required this.category,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding:EdgeInsets.all(0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Added for better alignment
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4), 
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff479E7D),
                  ),
                ),
              ],
            ),
            Text(
              '₹$amount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
