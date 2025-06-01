import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Homepage/AddTransactionbutton.dart';
import 'package:myapp/UI%20component/Homepage/ExpenseCard.dart';
import 'package:myapp/UI%20component/Homepage/StatusBarPage.dart';
import 'package:myapp/UI%20component/Homepage/appbar.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';

class HomePageUI extends StatelessWidget {
  final String fixedUID = 'qkIThgX4FqafhY5aeRIA';

  const HomePageUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FCFA),
      appBar: const HomePageAppBar(),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('User').doc(fixedUID).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No data found for this user."));
          }

          final userData = snapshot.data!.data();
          final totalIncome = (userData?['totatIncome'] ?? 0) as num;

          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('User')
                .doc(fixedUID)
                .collection('expenses')
                .orderBy('date', descending: true)
                .get(),
            builder: (context, expenseSnapshot) {
              if (expenseSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (expenseSnapshot.hasError) {
                return Center(child: Text('Error: ${expenseSnapshot.error}'));
              }
              if (!expenseSnapshot.hasData) {
                return const Center(child: Text('No expenses found.'));
              }

              final expenses = expenseSnapshot.data!.docs;
              final totalExpense = expenses.fold<int>(
                0,
                (sum, doc) => sum + ((doc['amount'] ?? 0) as num).toInt(),
              );

              final currentBalance = totalIncome.toInt() - totalExpense;
              final recentExpenses = expenses.take(3).toList();
              final percentSpent = totalIncome > 0 ? totalExpense / totalIncome : 0.0;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '₹$currentBalance',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Text(
                        "Current Balance",
                        style: TextStyle(color: Color(0xff479E7D), fontSize: 14),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Addtransactionbutton(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StatusBarPage(
                                totalIncome: totalIncome.toInt(),
                                totalExpense: totalExpense,
                              ),
                            ),
                          );
                        },
                        child: LinearProgressIndicator(
                          value: percentSpent,
                          backgroundColor: Colors.grey.shade300,
                          color: const Color(0xff05E38F),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: Text(
                        'Spent: ₹$totalExpense of ₹${totalIncome.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentExpenses.length,
                      itemBuilder: (context, index) {
                        final data = recentExpenses[index].data();
                        final amount = data['amount']?.toString() ?? '0';
                        final category = data['category'] ?? 'Unknown';
                        final description = data['description'] ?? 'Unknown';

                        return ExpenseCard(category: category, amount: amount,description: description);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomButton(
                          label: "See All",
                          onPressed: () {},
                          color: const Color(0xffE5F5F0),
                          textColor: Colors.black,
                          borderRadius: 12,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
