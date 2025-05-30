import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatusBarPage extends StatelessWidget {
  final int totalIncome;
  final int totalExpense;

  const StatusBarPage({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final currentBalance = totalIncome - totalExpense;
    final percentSpent = totalIncome > 0 ? totalExpense / totalIncome : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Overview"),
        backgroundColor: const Color(0xff05E38F),
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xffF7FCFA),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("₹$currentBalance",
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Current Balance",
                style: TextStyle(color: Color(0xff479E7D), fontSize: 16)),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: percentSpent,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xff05E38F),
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 10),
            Text(
              "Spent: ₹$totalExpense of ₹$totalIncome",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      value: totalExpense.toDouble(),
                      title: 'Spent',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: currentBalance.toDouble(),
                      title: 'Remaining',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Icon(
                percentSpent < 0.5
                    ? Icons.mood
                    : percentSpent < 0.8
                        ? Icons.mood_bad
                        : Icons.warning_amber,
                size: 60,
                color: percentSpent < 0.5
                    ? Colors.green
                    : percentSpent < 0.8
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                percentSpent < 0.5
                    ? "You're on track!"
                    : percentSpent < 0.8
                        ? "Caution: Spending rising"
                        : "Warning: Spending too much!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: percentSpent < 0.5
                      ? Colors.green
                      : percentSpent < 0.8
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
