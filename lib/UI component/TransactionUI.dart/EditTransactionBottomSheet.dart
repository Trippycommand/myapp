import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_theme.dart';

class EditTransactionBottomSheet
    extends StatefulWidget {

  final String documentId;

  final Map<String, dynamic> data;

  const EditTransactionBottomSheet({
    super.key,
    required this.documentId,
    required this.data,
  });

  @override
  State<EditTransactionBottomSheet>
      createState() =>
          _EditTransactionBottomSheetState();
}

class _EditTransactionBottomSheetState
    extends State<
        EditTransactionBottomSheet> {

  late TextEditingController
      amountController;

  late TextEditingController
      titleController;

  late TextEditingController
      noteController;

  late String selectedType;

  late String selectedCategory;

  late DateTime selectedDate;

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

  @override
  void initState() {
    super.initState();

    amountController =
        TextEditingController(
      text:
          widget.data["amount"]
              .toString(),
    );

    titleController =
        TextEditingController(
      text:
          widget.data["title"] ?? "",
    );

    noteController =
        TextEditingController(
      text:
          widget.data["note"] ?? "",
    );

    selectedType =
        widget.data["type"] ??
            "Expense";

    selectedCategory =
        widget.data["category"] ??
            "Food";

    selectedDate =
        (widget.data["date"]
                as Timestamp)
            .toDate();
  }

  Future<void> updateTransaction()
  async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {

      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(user.uid)
          .collection(
            "transactions",
          )
          .doc(widget.documentId)
          .update({

        "amount":
            double.tryParse(
                  amountController.text,
                ) ??
                0,

        "title":
            titleController.text.trim(),

        "note":
            noteController.text.trim(),

        "type":
            selectedType,

        "category":
            selectedCategory,

        "date":
            Timestamp.fromDate(
          selectedDate,
        ),
      });

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

  Future<void> deleteTransaction()
  async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore
        .instance
        .collection("users")
        .doc(user.uid)
        .collection(
          "transactions",
        )
        .doc(widget.documentId)
        .delete();

    if (!mounted) return;

    Navigator.pop(context);
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
              "Edit Transaction",

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

            buildField(
              "Amount",
              amountController,
              isNumber: true,
            ),

            const SizedBox(height: 18),

            buildField(
              "Title",
              titleController,
            ),

            const SizedBox(height: 24),

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

            buildField(
              "Note (Optional)",
              noteController,
            ),

            const SizedBox(height: 24),

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

            GestureDetector(
              onTap:
                  isLoading
                      ? null
                      : updateTransaction,

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
                ),

                child: Center(
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            color:
                                Colors.white,
                          )
                          : Text(
                            "Save Changes",

                            style:
                                GoogleFonts.manrope(
                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.w700,

                              fontSize: 16,
                            ),
                          ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            GestureDetector(
              onTap: deleteTransaction,

              child: Container(
                height: 58,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.red.shade50,

                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),

                child: Center(
                  child: Text(
                    "Delete Transaction",

                    style:
                        GoogleFonts.manrope(
                      color:
                          Colors.red,

                      fontWeight:
                          FontWeight.w700,
                    ),
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

      decoration: InputDecoration(
        hintText: hint,

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

