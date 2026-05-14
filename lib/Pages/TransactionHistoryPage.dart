import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/EditTransactionBottomSheet.dart';
import 'package:myapp/UI%20component/TransactionUI/EditTransactionBottomSheet.dart';
import 'package:myapp/core/theme/app_theme.dart';

class TransactionHistoryPage
    extends StatelessWidget {

  const TransactionHistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {

      return const Scaffold(
        body: Center(
          child: Text("No User Found"),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            AppColors.background,

        title: Text(
          "All Transactions",

          style:
              GoogleFonts.manrope(
            fontWeight:
                FontWeight.w800,

            color:
                AppColors.primary,
          ),
        ),
      ),

      body:
          StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .collection(
                  "transactions",
                )
                .orderBy(
                  "date",
                  descending: true,
                )
                .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final transactions =
              snapshot.data?.docs ?? [];

          if (transactions.isEmpty) {

            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons
                        .account_balance_wallet_outlined,

                    size: 70,

                    color:
                        Colors.grey.shade400,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  Text(
                    "No Transactions Yet",

                    style:
                        GoogleFonts.manrope(
                      fontSize: 24,

                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    "Your transaction history will appear here.",

                    style:
                        GoogleFonts.inter(
                      color:
                          AppColors.secondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(20),

            itemCount:
                transactions.length,

            itemBuilder:
                (context, index) {

              final data =
                  transactions[index]
                          .data()
                      as Map<String,
                          dynamic>;

              final title =
                  data["title"] ?? "";

              final category =
                  data["category"] ??
                      "";

              final amount =
                  (data["amount"] ??
                          0)
                      .toDouble();

              final type =
                  data["type"] ?? "";

              final bool isExpense =
                  type == "Expense";

              return GestureDetector(

                onTap: () {

                  showModalBottomSheet(
                    context: context,

                    isScrollControlled:
                        true,

                    backgroundColor:
                        Colors.transparent,

                    builder: (_) =>
                        EditTransactionBottomSheet(

                      documentId:
                          transactions[index].id,

                      data: data,
                    ),
                  );
                },

                child: Container(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),

                  padding:
                      const EdgeInsets.all(
                    18,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.03,
                        ),

                        blurRadius: 10,

                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 52,
                        height: 52,

                        decoration:
                            BoxDecoration(
                          color:
                              isExpense
                                  ? const Color(
                                    0xff231500,
                                  ).withOpacity(
                                    0.1,
                                  )
                                  : const Color(
                                    0xff64748B,
                                  ).withOpacity(
                                    0.1,
                                  ),

                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),

                        child: Icon(
                          isExpense
                              ? Icons
                                  .arrow_upward_rounded
                              : Icons
                                  .arrow_downward_rounded,

                          color:
                              isExpense
                                  ? const Color(
                                    0xff231500,
                                  )
                                  : const Color(
                                    0xff64748B,
                                  ),
                        ),
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(
                              title,

                              style:
                                  GoogleFonts.manrope(
                                fontWeight:
                                    FontWeight
                                        .w700,

                                fontSize:
                                    16,

                                color:
                                    AppColors
                                        .primary,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              category,

                              style:
                                  GoogleFonts.inter(
                                color:
                                    AppColors
                                        .secondary,

                                fontSize:
                                    13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "${isExpense ? "-" : "+"}₹${amount.toStringAsFixed(0)}",

                        style:
                            GoogleFonts.manrope(
                          fontWeight:
                              FontWeight
                                  .w800,

                          fontSize: 16,

                          color:
                              isExpense
                                  ? const Color(
                                    0xff231500,
                                  )
                                  : const Color(
                                    0xff64748B,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}