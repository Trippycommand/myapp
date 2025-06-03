import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/appbar.dart';
import 'package:myapp/UI%20component/Homepage/ExpenseCard.dart';

class TransactionPageUI extends StatefulWidget {
  final String fixedUID = 'qkIThgX4FqafhY5aeRIA';
  const TransactionPageUI({super.key});

  @override
  State<TransactionPageUI> createState() => _TransactionPageUIState();
}

class _TransactionPageUIState extends State<TransactionPageUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5F5F0),
      appBar: const TransactionAppBar(),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance
                .collection('User')
                .doc(widget.fixedUID)
                .collection('expenses')
                .orderBy('date', descending: true)
                .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No transaction history found."));
          }

          final transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final data = transactions[index].data();
              final amount = data['amount']?.toString() ?? '0';
              final category = data['category'] ?? 'Unknown';
              final timestamp = data['date'] as Timestamp?;
              final date =
                  timestamp != null ? timestamp.toDate() : DateTime.now();

              final formattedDate = "${date.day}/${date.month}/${date.year}";

              return ExpenseCard(
                category: category,
                amount: amount,
                description: formattedDate,
              );
            },
          );
        },
      ),
    );
  }
}
