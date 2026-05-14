import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/models/transaction_model.dart';

class AddTransactionBottomSheet
    extends StatefulWidget {

  const AddTransactionBottomSheet({
    super.key,
  });

  @override
  State<AddTransactionBottomSheet>
      createState() =>
          _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState
    extends State<
        AddTransactionBottomSheet> {

  final amountController =
      TextEditingController();

  final titleController =
      TextEditingController();

  final noteController =
      TextEditingController();

  String selectedType =
      "Expense";

  String selectedCategory =
      "Food";

  DateTime selectedDate =
      DateTime.now();

  bool isLoading = false;

  final Map<String, List<String>>
      categoryMap = {

    "Expense": [
      "Food",
      "Transport",
      "Shopping",
      "Bills",
      "Entertainment",
      "Travel",
      "Health",
      "Education",
      "Groceries",
      "Rent",
      "Other",
    ],

    "Income": [
      "Salary",
      "Freelance",
      "Business",
      "Bonus",
      "Investment",
      "Gift",
      "Other",
    ],

    "Received": [
      "Friend",
      "Family",
      "Refund",
      "Split Bill",
      "Cashback",
      "Other",
    ],
  };

  Future<void> saveTransaction() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (amountController.text.isEmpty ||
        titleController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please fill required fields",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      final doc =
          FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection(
                "transactions",
              )
              .doc();

      final transaction =
          TransactionModel(
        id: doc.id,

        title:
            titleController.text.trim(),

        amount:
            double.tryParse(
                  amountController.text,
                ) ??
                0,

        type:
            selectedType,

        category:
            selectedCategory,

        note:
            noteController.text.trim(),

        date:
            selectedDate,

        createdAt:
            Timestamp.now(),
      );

      await doc.set(
        transaction.toMap(),
      );

      if (!mounted) return;

      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickDate() async {

    DateTime? picked =
        await showDatePicker(
      context: context,

      initialDate:
          selectedDate,

      firstDate:
          DateTime(2020),

      lastDate:
          DateTime.now(),
    );

    if (picked != null) {

      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
          EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,

        bottom:
            MediaQuery.of(context)
                .viewInsets
                .bottom +
            24,
      ),

      decoration:
          const BoxDecoration(
        color: Color(0xffF8FAFC),

        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      child: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Center(
              child: Container(
                width: 50,
                height: 5,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.grey.shade300,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Add Transaction",

              style:
                  GoogleFonts.manrope(
                fontSize: 30,

                fontWeight:
                    FontWeight.w800,

                color:
                    AppColors.primary,
              ),
            ),

            const SizedBox(height: 30),

            // AMOUNT
            buildField(
              "Amount",
              amountController,
              isNumber: true,
            ),

            const SizedBox(height: 18),

            // TITLE
            buildField(
              "Title",
              titleController,
            ),

            const SizedBox(height: 24),

            // TYPE CHIPS
            Text(
              "Type",

              style:
                  GoogleFonts.manrope(
                fontWeight:
                    FontWeight.w700,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [

                buildTypeChip(
                  "Expense",
                ),

                const SizedBox(width: 10),

                buildTypeChip(
                  "Income",
                ),

                const SizedBox(width: 10),

                buildTypeChip(
                  "Received",
                ),
              ],
            ),

            const SizedBox(height: 24),

            // CATEGORY
            Text(
              "Category",

              style:
                  GoogleFonts.manrope(
                fontWeight:
                    FontWeight.w700,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 14),

            buildCategoryDropdown(),

            const SizedBox(height: 18),

            // NOTE
            buildField(
              "Note (Optional)",
              noteController,
            ),

            const SizedBox(height: 24),

            // DATE
            GestureDetector(
              onTap: pickDate,

              child: Container(
                height: 60,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                ),

                decoration:
                    BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),

                  border: Border.all(
                    color:
                        AppColors.border,
                  ),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [

                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

                      style:
                          AppTextStyles.body,
                    ),

                    const Icon(
                      Icons
                          .calendar_month_rounded,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            GestureDetector(
              onTap:
                  isLoading
                      ? null
                      : saveTransaction,

              child: Container(
                height: 62,

                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primary,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(
                        0.08,
                      ),

                      blurRadius: 14,

                      offset:
                          const Offset(
                        0,
                        8,
                      ),
                    ),
                  ],
                ),

                child: Center(
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                          : Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Text(
                                "Save Transaction",

                                style:
                                    GoogleFonts.manrope(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight.w700,

                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              const Icon(
                                Icons
                                    .arrow_forward_rounded,

                                color:
                                    Colors.white,
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTypeChip(
    String type,
  ) {

    final isSelected =
        selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {

          setState(() {

            selectedType = type;

            selectedCategory =
                categoryMap[type]!.first;
          });
        },

        child: Container(
          height: 52,

          decoration:
              BoxDecoration(
            color:
                isSelected
                    ? AppColors.primary
                    : Colors.white,

            borderRadius:
                BorderRadius.circular(
              16,
            ),

            border: Border.all(
              color:
                  AppColors.border,
            ),
          ),

          child: Center(
            child: Text(
              type,

              style:
                  GoogleFonts.manrope(
                color:
                    isSelected
                        ? Colors.white
                        : Colors.black,

                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:
              selectedCategory,

          isExpanded: true,

          style:
              GoogleFonts.inter(
            color:
                Colors.black,

            fontSize: 15,
          ),

          items:
              categoryMap[selectedType]!
                  .map(
                    (category) =>
                        DropdownMenuItem(
                      value: category,

                      child:
                          Text(category),
                    ),
                  )
                  .toList(),

          onChanged: (value) {

            setState(() {
              selectedCategory =
                  value!;
            });
          },
        ),
      ),
    );
  }

  Widget buildField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {

    return TextField(
      controller: controller,

      keyboardType:
          isNumber
              ? TextInputType.number
              : TextInputType.text,

      style:
          GoogleFonts.inter(
        fontSize: 15,
        color: Colors.black,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle:
            AppTextStyles.body,

        filled: true,
        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            18,
          ),

          borderSide: BorderSide(
            color:
                AppColors.border,
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            18,
          ),

          borderSide: BorderSide(
            color:
                AppColors.border,
          ),
        ),

        focusedBorder:
            const OutlineInputBorder(
          borderRadius:
              BorderRadius.all(
            Radius.circular(18),
          ),

          borderSide: BorderSide(
            color:
                AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}