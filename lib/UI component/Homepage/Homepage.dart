import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/UI%20component/Homepage/appbar.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/AddTransactionBottomSheet.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/Pages/TransactionHistoryPage.dart';
import 'package:myapp/UI%20component/Homepage/WeeklySpendingChart.dart';
import 'package:myapp/UI component/VoiceAssistantBottomSheet.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  State<HomePageUI> createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _spokenText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print("STATUS: $status");
        },
        onError: (error) {
          print("ERROR: $error");
        },
      );
      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          listenMode: stt.ListenMode.confirmation,
          onResult: (result) {
            print(result.recognizedWords);

            setState(() {
              _spokenText = result.recognizedWords;
            });

            if (result.finalResult) {
              _processVoiceCommand(result.recognizedWords);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _processVoiceCommand(String text) async {
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Couldn't hear anything")));
      return;
    }

    final lowerText = text.toLowerCase();

    String type = "Expense";
    String category = "Other";

    if (lowerText.contains("salary")) {
      type = "Income";
      category = "Salary";
    } else if (lowerText.contains("food")) {
      category = "Food";
    } else if (lowerText.contains("uber")) {
      category = "Travel";
    } else if (lowerText.contains("netflix")) {
      category = "Entertainment";
    }
    String title = "Expense";

    if (category == "Food") {
      title = "Food Expense";
    } else if (category == "Travel") {
      title = "Uber Ride";
    } else if (category == "Entertainment") {
      title = "Netflix Subscription";
    } else if (category == "Salary") {
      title = "Monthly Salary";
    }

    final amountMatch = RegExp(r'\d+').firstMatch(text);

    if (category == "Other") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't understand transaction")),
      );
      return;
    }

    if (amountMatch != null) {
      final amount = double.parse(amountMatch.group(0)!);

      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("transactions")
          .add({
            "title": title,
            "amount": amount,
            "category": category,
            "type": type,
            "date": Timestamp.now(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$category transaction added successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Amount not detected")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No User Found")));
    }

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const HomePageAppBar(),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // MIC BUTTON
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder:
                    (_) => VoiceAssistantBottomSheet(
                      speech: _speech,
                      onResult: (text) async {
                        setState(() {
                          _spokenText = text;
                        });

                        await _processVoiceCommand(text);
                      },
                    ),
              );
            },
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          const SizedBox(width: 20),

          // EXISTING + BUTTON
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AddTransactionBottomSheet(),
              );
            },
            child: Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .collection("transactions")
                .orderBy("date", descending: true)
                .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data?.docs ?? [];

          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .get(),

            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>?;

              final double monthlySalary =
                  (userData?["monthlyIncome"] ?? 0).toDouble();

              double income = 0;
              double expense = 0;
              double received = 0;

              for (var doc in transactions) {
                final data = doc.data() as Map<String, dynamic>;

                final amount = (data["amount"] ?? 0).toDouble();

                final type = data["type"] ?? "";

                if (type == "Income") {
                  income += amount;
                } else if (type == "Expense") {
                  expense += amount;
                } else if (type == "Received") {
                  received += amount;
                }
              }

              // ADD VIRTUAL SALARY
              income += monthlySalary;

              final balance = income + received - expense;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 120,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // BALANCE CARD
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(28),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),

                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,

                          end: Alignment.bottomRight,

                          colors: [
                            Color(0xff0B1220),

                            Color(0xff111827),

                            Color(0xff172033),
                          ],
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff0F172A).withOpacity(0.18),

                            blurRadius: 30,

                            spreadRadius: 2,

                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),

                      child: Stack(
                        children: [
                          // BACKGROUND GLOW
                          Positioned(
                            right: -30,
                            top: 10,

                            child: Container(
                              width: 150,
                              height: 150,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.10),

                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "TOTAL BALANCE",

                                            style: GoogleFonts.inter(
                                              color: Colors.white70,

                                              fontSize: 12,

                                              letterSpacing: 1.2,

                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          const SizedBox(width: 6),

                                          Icon(
                                            Icons.info_outline,

                                            size: 14,

                                            color: Colors.white54,
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      Text(
                                        "₹${balance.toStringAsFixed(0)}",

                                        style: GoogleFonts.manrope(
                                          color: Colors.white,

                                          fontSize: 42,

                                          fontWeight: FontWeight.w800,

                                          height: 1,
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.trending_up_rounded,

                                            color: const Color(0xff10B981),

                                            size: 18,
                                          ),

                                          const SizedBox(width: 6),

                                          Text(
                                            "+2.4% from last month",

                                            style: GoogleFonts.inter(
                                              color: const Color(0xff10B981),

                                              fontWeight: FontWeight.w600,

                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 58,

                                      decoration: BoxDecoration(
                                        color: Colors.white,

                                        borderRadius: BorderRadius.circular(18),
                                      ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          const Icon(
                                            Icons.arrow_upward_rounded,

                                            size: 20,

                                            color: Colors.black,
                                          ),

                                          const SizedBox(width: 8),

                                          Text(
                                            "Send",

                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w700,

                                              fontSize: 16,

                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Container(
                                      height: 58,

                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.10),

                                        borderRadius: BorderRadius.circular(18),

                                        border: Border.all(
                                          color: Colors.white24,
                                        ),
                                      ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,

                                        children: [
                                          const Icon(
                                            Icons.download_rounded,

                                            size: 20,

                                            color: Colors.white,
                                          ),

                                          const SizedBox(width: 8),

                                          Text(
                                            "Request",

                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w700,

                                              fontSize: 16,

                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // QUICK STATS
                    Row(
                      children: [
                        Expanded(
                          child: buildStatCard(
                            "Income",

                            "₹${income.toStringAsFixed(0)}",

                            Icons.arrow_downward_rounded,

                            const Color(0xff64748B),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: buildStatCard(
                            "Expense",

                            "₹${expense.toStringAsFixed(0)}",

                            Icons.arrow_upward_rounded,

                            const Color(0xff231500),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: buildStatCard(
                            "Received",

                            "₹${received.toStringAsFixed(0)}",

                            Icons.payments_rounded,

                            const Color(0xff0F172A),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          "Recent Transactions",

                          style: GoogleFonts.manrope(
                            fontSize: 22,

                            fontWeight: FontWeight.w800,

                            color: AppColors.primary,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const TransactionHistoryPage(),
                              ),
                            );
                          },

                          child: Text(
                            "See All",

                            style: GoogleFonts.inter(
                              color: AppColors.secondary,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // EMPTY STATE
                    if (transactions.isEmpty)
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(40),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(28),
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,

                              size: 64,

                              color: Colors.grey.shade400,
                            ),

                            const SizedBox(height: 18),

                            Text(
                              "No Transactions Yet",

                              style: GoogleFonts.manrope(
                                fontSize: 22,

                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Tap the + button to add your first transaction.",

                              textAlign: TextAlign.center,

                              style: GoogleFonts.inter(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // SCROLLABLE TRANSACTIONS
                    SizedBox(
                      height: 330,

                      child: ListView.builder(
                        itemCount:
                            transactions.length > 6 ? 6 : transactions.length,

                        physics: const BouncingScrollPhysics(),

                        itemBuilder: (context, index) {
                          final data =
                              transactions[index].data()
                                  as Map<String, dynamic>;

                          final title = data["title"] ?? "";

                          final category = data["category"] ?? "";

                          final amount = (data["amount"] ?? 0).toDouble();

                          final type = data["type"] ?? "";

                          final bool isExpense = type == "Expense";

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.circular(24),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),

                                  blurRadius: 10,

                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),

                            child: Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,

                                  decoration: BoxDecoration(
                                    color:
                                        isExpense
                                            ? const Color(
                                              0xff231500,
                                            ).withOpacity(0.1)
                                            : const Color(
                                              0xff64748B,
                                            ).withOpacity(0.1),

                                    borderRadius: BorderRadius.circular(14),
                                  ),

                                  child: Icon(
                                    isExpense
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded,

                                    color:
                                        isExpense
                                            ? const Color(0xff231500)
                                            : const Color(0xff64748B),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        title,

                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w700,

                                          fontSize: 16,

                                          color: AppColors.primary,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        category,

                                        style: GoogleFonts.inter(
                                          color: AppColors.secondary,

                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  "${isExpense ? "-" : "+"}₹${amount.toStringAsFixed(0)}",

                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,

                                    fontSize: 16,

                                    color:
                                        isExpense
                                            ? const Color(0xff231500)
                                            : const Color(0xff64748B),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // WEEKLY SPENDING CHART
                    const WeeklySpendingChart(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildStatCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 40,
            height: 40,

            decoration: BoxDecoration(
              color: color.withOpacity(0.1),

              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 16),

          Text(
            title,

            style: GoogleFonts.inter(color: AppColors.secondary, fontSize: 13),
          ),

          const SizedBox(height: 6),

          Text(
            amount,

            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,

              fontSize: 16,

              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
