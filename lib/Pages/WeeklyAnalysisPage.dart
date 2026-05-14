import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_theme.dart';

enum ChartType { bar, line }

class WeeklyAnalysisPage extends StatefulWidget {
  const WeeklyAnalysisPage({super.key});

  @override
  State<WeeklyAnalysisPage> createState() => _WeeklyAnalysisPageState();
}

class _WeeklyAnalysisPageState extends State<WeeklyAnalysisPage> {
  ChartType selectedChart = ChartType.bar;

  bool isDayMode = false;

  String selectedDay = "";

  double selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No User Found")));
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,

        backgroundColor: AppColors.background,

        title: Text(
          "Weekly Analysis",

          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,

            color: AppColors.primary,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
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

          final now = DateTime.now();

          Map<String, double> dailyTotals = {};

          List<String> dynamicDays = [];

          for (int i = 6; i >= 0; i--) {
            final day = now.subtract(Duration(days: i));

            final label = getDayLabel(day.weekday);

            dynamicDays.add(label);

            dailyTotals[label] = 0;
          }

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;

            final type = data["type"];

            if (type != "Expense") {
              continue;
            }

            final amount = (data["amount"] ?? 0).toDouble();

            final date = (data["date"] as Timestamp).toDate();

            final difference = now.difference(date).inDays;

            if (difference > 6) {
              continue;
            }

            final label = getDayLabel(date.weekday);

            if (dailyTotals.containsKey(label)) {
              dailyTotals[label] = dailyTotals[label]! + amount;
            }
          }

          final weeklySpending =
              dynamicDays.map((day) => dailyTotals[day] ?? 0).toList();

          final weeklyTotal = weeklySpending.fold<double>(0.0, (a, b) => a + b);

          final averageSpend = weeklyTotal / 7;

          final highestSpend = weeklySpending.reduce((a, b) => a > b ? a : b);

          final highestIndex = weeklySpending.indexOf(highestSpend);

          Map<String, double> categoryTotals = {};

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;

            final type = data["type"];

            if (type != "Expense") {
              continue;
            }

            final amount = (data["amount"] ?? 0).toDouble();

            final category = data["category"] ?? "Other";

            final date = (data["date"] as Timestamp).toDate();

            final difference = now.difference(date).inDays;

            if (!isDayMode) {
              if (difference > 6) {
                continue;
              }
            } else {
              final selectedIndex = dynamicDays.indexOf(selectedDay);

              final selectedDate = now.subtract(
                Duration(days: 6 - selectedIndex),
              );

              if (date.day != selectedDate.day ||
                  date.month != selectedDate.month ||
                  date.year != selectedDate.year) {
                continue;
              }
            }

            if (categoryTotals.containsKey(category)) {
              categoryTotals[category] = categoryTotals[category]! + amount;
            } else {
              categoryTotals[category] = amount;
            }
          }

          final sortedCategories =
              categoryTotals.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

          final highestCategoryAmount =
              sortedCategories.isEmpty ? 1.0 : sortedCategories.first.value;

          List<String> insights = [];

          final maxSpend = weeklySpending.reduce((a, b) => a > b ? a : b);

          final minSpend = weeklySpending.reduce((a, b) => a < b ? a : b);

          if (isDayMode) {
            insights.add(
              "$selectedDay spending reached ₹${selectedAmount.toStringAsFixed(0)}.",
            );

            if (sortedCategories.isNotEmpty) {
              insights.add(
                "${sortedCategories.first.key} was your biggest expense category.",
              );
            }

            insights.add(
              "You recorded ${sortedCategories.length} active spending categories.",
            );
          } else {
            insights.add(
              "${dynamicDays[highestIndex]} was your highest spending day.",
            );

            insights.add(
              "Your average daily spending was ₹${averageSpend.toStringAsFixed(0)}.",
            );

            if (sortedCategories.isNotEmpty) {
              insights.add(
                "${sortedCategories.first.key} accounted for most of your spending.",
              );
            }

            if (maxSpend - minSpend < averageSpend * 0.5) {
              insights.add("Your spending pattern remained stable this week.");
            } else {
              insights.add("Your spending fluctuated significantly this week.");
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(28),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff0B1220), Color(0xff172033)],
                    ),

                    borderRadius: BorderRadius.circular(34),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        isDayMode ? "$selectedDay Spending" : "Weekly Spending",

                        style: GoogleFonts.inter(
                          color: Colors.white70,

                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        isDayMode
                            ? "₹${selectedAmount.toStringAsFixed(0)}"
                            : "₹${weeklyTotal.toStringAsFixed(0)}",

                        style: GoogleFonts.manrope(
                          color: Colors.white,

                          fontSize: 42,

                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        isDayMode ? "Selected Day Analysis" : "Last 7 Days",

                        style: GoogleFonts.inter(
                          color: Colors.white60,

                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      "Spending Trends",

                      style: GoogleFonts.manrope(
                        fontSize: 24,

                        fontWeight: FontWeight.w800,

                        color: AppColors.primary,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(4),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Row(
                        children: [
                          buildToggle(
                            icon: Icons.bar_chart_rounded,

                            isSelected: selectedChart == ChartType.bar,

                            onTap: () {
                              setState(() {
                                selectedChart = ChartType.bar;
                              });
                            },
                          ),

                          buildToggle(
                            icon: Icons.show_chart_rounded,

                            isSelected: selectedChart == ChartType.line,

                            onTap: () {
                              setState(() {
                                selectedChart = ChartType.line;

                                isDayMode = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(32),
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: buildMiniCard(
                              title: "AVG SPEND",

                              value: "₹${averageSpend.toStringAsFixed(0)}",

                              color: const Color(0xff10B981),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: buildMiniCard(
                              title: "HIGHEST",

                              value: dynamicDays[highestIndex],

                              subtitle: "₹${highestSpend.toStringAsFixed(0)}",

                              color: const Color(0xffEF4444),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        height: 300,

                        child:
                            selectedChart == ChartType.bar
                                ? BarChart(
                                  buildBarChart(
                                    context,
                                    weeklySpending,
                                    dynamicDays,
                                    highestSpend,
                                    averageSpend,
                                  ),
                                )
                                : LineChart(
                                  buildLineChart(
                                    weeklySpending,
                                    dynamicDays,
                                    highestSpend,
                                    averageSpend,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  "Weekly Insights",

                  style: GoogleFonts.manrope(
                    fontSize: 24,

                    fontWeight: FontWeight.w800,

                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 18),

                ...insights.map((insight) {
                  return buildInsightCard(insight);
                }),

                const SizedBox(height: 34),

                Text(
                  "Top Categories",

                  style: GoogleFonts.manrope(
                    fontSize: 24,

                    fontWeight: FontWeight.w800,

                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 18),

                ...sortedCategories.take(5).map((category) {
                  final progress = category.value / highestCategoryAmount;

                  return buildCategoryTile(
                    category.key,
                    "₹${category.value.toStringAsFixed(0)}",
                    progress,
                  );
                }),
              ],
            ),
          );
        },
      ),
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

  Widget buildToggle({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,

          borderRadius: BorderRadius.circular(12),
        ),

        child: Icon(
          icon,

          color: isSelected ? Colors.white : AppColors.secondary,
        ),
      ),
    );
  }

  Widget buildMiniCard({
    required String title,
    required String value,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),

        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: GoogleFonts.inter(
              fontSize: 11,

              fontWeight: FontWeight.w700,

              letterSpacing: 1,

              color: color,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,

            style: GoogleFonts.manrope(
              fontSize: 24,

              fontWeight: FontWeight.w800,

              color: AppColors.primary,
            ),
          ),

          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),

              child: Text(
                subtitle,

                style: GoogleFonts.inter(
                  fontSize: 13,

                  fontWeight: FontWeight.w600,

                  color: color,
                ),
              ),
            ),
        ],
      ),
    );
  }

  BarChartData buildBarChart(
    BuildContext context,

    List<double> weeklySpending,

    List<String> dynamicDays,

    double highestSpend,

    double averageSpend,
  ) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,

      maxY: highestSpend * 1.35,

      barTouchData: BarTouchData(
        enabled: true,

        touchCallback: (event, response) {
          if (response == null) {
            return;
          }

          if (response.spot == null) {
            return;
          }

          final index = response.spot!.touchedBarGroupIndex;

          setState(() {
            isDayMode = true;

            selectedDay = dynamicDays[index];

            selectedAmount = weeklySpending[index];
          });
        },
      ),

      gridData: FlGridData(
        show: true,

        drawVerticalLine: false,

        horizontalInterval: averageSpend,

        getDrawingHorizontalLine: (value) {
          if ((value - averageSpend).abs() < 1) {
            return FlLine(
              color: Colors.grey.shade300,

              strokeWidth: 1.3,

              dashArray: [6, 6],
            );
          }

          return FlLine(color: Colors.transparent);
        },
      ),

      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,

            reservedSize: 38,

            interval: 1,

            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) {
                return const SizedBox();
              }

              final index = value.toInt();

              if (index < 0 || index >= dynamicDays.length) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 12),

                child: Text(
                  dynamicDays[index],

                  style: GoogleFonts.inter(
                    fontSize: 11,

                    fontWeight: FontWeight.w600,

                    color: AppColors.secondary,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      barGroups: List.generate(weeklySpending.length, (index) {
        final isSelected = isDayMode && selectedDay == dynamicDays[index];

        return BarChartGroupData(
          x: index,

          barRods: [
            BarChartRodData(
              toY: weeklySpending[index],

              width: 20,

              borderRadius: BorderRadius.circular(8),

              color:
                  isSelected
                      ? const Color(0xff0F172A)
                      : weeklySpending[index] >= highestSpend * 0.75
                      ? const Color(0xffEF4444)
                      : weeklySpending[index] >= highestSpend * 0.40
                      ? const Color(0xffF59E0B)
                      : const Color(0xff10B981),

              backDrawRodData: BackgroundBarChartRodData(
                show: true,

                toY: highestSpend * 1.3,

                color: Colors.grey.shade100,
              ),
            ),
          ],
        );
      }),
    );
  }

  LineChartData buildLineChart(
    List<double> weeklySpending,
    List<String> dynamicDays,
    double highestSpend,
    double averageSpend,
  ) {
    return LineChartData(
      minY: -200,

      maxY: highestSpend * 1.35,

      gridData: FlGridData(
        show: true,

        drawVerticalLine: false,

        horizontalInterval: averageSpend,

        getDrawingHorizontalLine: (value) {
          if ((value - averageSpend).abs() < 1) {
            return FlLine(
              color: Colors.grey.shade300,

              strokeWidth: 1.3,

              dashArray: [6, 6],
            );
          }

          return FlLine(color: Colors.transparent);
        },
      ),

      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,

            reservedSize: 38,

            interval: 1,

            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) {
                return const SizedBox();
              }

              final index = value.toInt();

              if (index < 0 || index >= dynamicDays.length) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 12),

                child: Text(
                  dynamicDays[index],

                  style: GoogleFonts.inter(
                    fontSize: 11,

                    fontWeight: FontWeight.w600,

                    color: AppColors.secondary,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      lineTouchData: const LineTouchData(enabled: false),

      lineBarsData: [
        LineChartBarData(
          isCurved: true,

          curveSmoothness: 0.08,

          gradient: const LinearGradient(
            colors: [Color(0xff10B981), Color(0xff3B82F6)],
          ),

          barWidth: 4,

          isStrokeCapRound: true,

          belowBarData: BarAreaData(
            show: true,

            gradient: LinearGradient(
              begin: Alignment.topCenter,

              end: Alignment.bottomCenter,

              colors: [
                const Color(0xff10B981).withOpacity(0.20),

                const Color(0xff10B981).withOpacity(0.02),
              ],
            ),
          ),

          dotData: FlDotData(
            show: true,

            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,

                color: Colors.white,

                strokeWidth: 2.5,

                strokeColor: const Color(0xff10B981),
              );
            },
          ),

          spots: List.generate(weeklySpending.length, (index) {
            return FlSpot(index.toDouble(), weeklySpending[index]);
          }),
        ),
      ],
    );
  }

  Widget buildInsightCard(String text) {
    IconData icon = Icons.auto_awesome_rounded;

    Color color = const Color(0xff3B82F6);

    String title = "Smart Insight";

    // HIGHEST SPENDING
    if (text.contains("highest")) {
      icon = Icons.trending_up_rounded;

      color = const Color(0xffEF4444);

      title = "Highest Spending";
    }
    // AVERAGE
    else if (text.contains("average")) {
      icon = Icons.analytics_rounded;

      color = const Color(0xff10B981);

      title = "Average Spending";
    }
    // CATEGORY
    else if (text.contains("category") ||
        text.contains("Food") ||
        text.contains("Entertainment")) {
      icon = Icons.pie_chart_rounded;

      color = const Color(0xffF59E0B);

      title = "Category Analysis";
    }
    // STABILITY
    else if (text.contains("stable")) {
      icon = Icons.shield_rounded;

      color = const Color(0xff10B981);

      title = "Spending Stability";
    }
    // VOLATILITY
    else if (text.contains("fluctuated")) {
      icon = Icons.warning_amber_rounded;

      color = const Color(0xffEF4444);

      title = "Spending Volatility";
    }
    // DAY MODE
    else if (text.contains("reached")) {
      icon = Icons.calendar_today_rounded;

      color = const Color(0xff8B5CF6);

      title = "Daily Analysis";
    }

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 18,

            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ICON
          Container(
            height: 48,
            width: 48,

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(icon, color: color, size: 24),
          ),

          const SizedBox(width: 16),

          // CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: GoogleFonts.manrope(
                    fontSize: 16,

                    fontWeight: FontWeight.w800,

                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  text,

                  style: GoogleFonts.inter(
                    fontSize: 13,

                    height: 1.5,

                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryTile(String title, String amount, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                title,

                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,

                  fontSize: 16,
                ),
              ),

              Text(
                amount,

                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,

                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: LinearProgressIndicator(
              value: progress,

              minHeight: 8,

              backgroundColor: Colors.grey.shade200,

              valueColor: const AlwaysStoppedAnimation(Color(0xff10B981)),
            ),
          ),
        ],
      ),
    );
  }
}
