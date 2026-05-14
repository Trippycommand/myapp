import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/Pages/WeeklyAnalysisPage.dart';

class WeeklySpendingChart extends StatelessWidget {
  const WeeklySpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const SizedBox();
    }

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("transactions")
              .orderBy("date", descending: false)
              .snapshots(),

      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        Map<String, double> dailyExpenses = {};

        List<String> dayLabels = [];

        final now = DateTime.now();

        // LAST 7 ACTIVE DAYS
        for (int i = 6; i >= 0; i--) {
          final day = now.subtract(Duration(days: i));

          final label = getDayLabel(day.weekday);

          dayLabels.add(label);

          dailyExpenses[label] = 0;
        }

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;

          final type = data["type"];

          if (type != "Expense") {
            continue;
          }

          final amount = (data["amount"] ?? 0).toDouble();

          final date = (data["date"] as Timestamp).toDate();

          final label = getDayLabel(date.weekday);

          if (dailyExpenses.containsKey(label)) {
            dailyExpenses[label] = dailyExpenses[label]! + amount;
          }
        }

        final values = dayLabels.map((day) => dailyExpenses[day] ?? 0).toList();

        final maxValue =
            values.isEmpty ? 100 : values.reduce((a, b) => a > b ? a : b);

        return Container(
          width: double.infinity,

          margin: const EdgeInsets.only(top: 10, bottom: 20),

          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(28),

            border: Border.all(color: Colors.grey.shade300),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Spending",

                        style: GoogleFonts.manrope(
                          fontSize: 28,

                          fontWeight: FontWeight.w700,

                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Last 7 Days",

                        style: GoogleFonts.inter(color: AppColors.secondary),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const WeeklyAnalysisPage(),
                        ),
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: const Color(0xffF8FAFC),

                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.insert_chart_outlined_rounded,

                        color: Color(0xff0F172A),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 34),

              SizedBox(
                height: 220,

                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,

                    maxY: maxValue == 0 ? 100 : maxValue * 1.3,

                    gridData: const FlGridData(show: false),

                    borderData: FlBorderData(show: false),

                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,

                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),

                              child: Text(
                                dayLabels[value.toInt()],

                                style: GoogleFonts.inter(
                                  fontSize: 12,

                                  color: AppColors.secondary,
                                ),
                              ),
                            );
                          },

                          reservedSize: 34,
                        ),
                      ),
                    ),

                    barGroups: List.generate(values.length, (index) {
                      return BarChartGroupData(
                        x: index,

                        barRods: [
                          BarChartRodData(
                            toY: values[index],

                            width: 28,

                            borderRadius: BorderRadius.circular(6),

                            color: const Color(0xff10B981),

                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,

                              toY: maxValue * 1.2,

                              color: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getDayLabel(int weekday) {
    switch (weekday) {
      case 1:
        return "MON";

      case 2:
        return "TUE";

      case 3:
        return "WED";

      case 4:
        return "THU";

      case 5:
        return "FRI";

      case 6:
        return "SAT";

      case 7:
        return "SUN";

      default:
        return "";
    }
  }
}
