import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Pages/HomePage.dart';
import 'package:myapp/core/theme/app_theme.dart';

class UserSetup extends StatefulWidget {
  const UserSetup({super.key});

  @override
  State<UserSetup> createState() =>
      _UserSetupState();
}

class _UserSetupState
    extends State<UserSetup> {

  final PageController pageController =
      PageController();

  int currentPage = 0;

  // CONTROLLERS
  final companyController =
      TextEditingController();

  final jobController =
      TextEditingController();

  final incomeController =
      TextEditingController();

  final goalController =
      TextEditingController();

  // DROPDOWNS
  String salaryFrequency =
      "Monthly";

  String selectedCurrency =
      "INR";

  // DATE
  DateTime? birthday;

  bool isLoading = false;

  Future<void> pickDate() async {

    DateTime? pickedDate =
        await showDatePicker(
      context: context,

      initialDate: DateTime(2000),

      firstDate: DateTime(1950),

      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {

      setState(() {
        birthday = pickedDate;
      });
    }
  }

  Future<void> saveUserData() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {

      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({

        // WORK PROFILE
        "companyName":
            companyController.text.trim(),

        "jobTitle":
            jobController.text.trim(),

        // INCOME
        "monthlyIncome":
            int.tryParse(
              incomeController.text,
            ) ??
            0,

        "salaryFrequency":
            salaryFrequency,

        "currency":
            selectedCurrency,

        // GOAL
        "financialGoal":
            goalController.text.trim(),

        // PERSONAL
        "birthday":
            birthday?.toString(),

        // FLAGS
        "profileCompleted": true,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(
          builder:
              (_) =>
                  const HomePage(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  void nextPage() {

    FocusScope.of(context).unfocus();

    if (currentPage < 2) {

      pageController.nextPage(
        duration:
            const Duration(milliseconds: 300),

        curve: Curves.easeInOut,
      );

    } else {

      saveUserData();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor:
          AppColors.background,

      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),

          child: Column(
            children: [

              const SizedBox(height: 10),

              // HEADER
              Row(
                children: [

                  Container(
                    height: 44,
                    width: 44,

                    decoration: BoxDecoration(
                      color:
                          AppColors.primary,

                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: const Icon(
                      Icons
                          .account_balance_wallet_rounded,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Text(
                    "VaultWise",

                    style:
                        GoogleFonts.manrope(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // PROGRESS BAR
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(20),

                child:
                    LinearProgressIndicator(
                  value:
                      (currentPage + 1) / 3,

                  minHeight: 8,

                  backgroundColor:
                      Colors.grey.shade300,

                  valueColor:
                      const AlwaysStoppedAnimation(
                    AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // PAGEVIEW
              Expanded(
                child: PageView(
                  controller:
                      pageController,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  onPageChanged: (index) {

                    setState(() {
                      currentPage = index;
                    });
                  },

                  children: [

                    // STEP 1
                    buildStep(
                      title:
                          "Tell us about your work.",

                      subtitle:
                          "We'll personalize your financial experience using this information.",

                      child: Column(
                        children: [

                          buildField(
                            "Company Name",
                            companyController,
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          buildField(
                            "Job Title",
                            jobController,
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          buildField(
                            "Monthly Salary",
                            incomeController,
                            isNumber: true,
                          ),

                          const SizedBox(
                            height: 18,
                          ),

                          buildDropdown(),

                          const SizedBox(
                            height: 18,
                          ),

                          buildCurrencyDropdown(),
                        ],
                      ),
                    ),

                    // STEP 2
                    buildStep(
                      title:
                          "What’s your financial goal?",

                      subtitle:
                          "Tell us what you're trying to achieve financially.",

                      child: buildField(
                        "Example: Save more, travel, invest, buy a car...",
                        goalController,
                      ),
                    ),

                    // STEP 3
                    buildStep(
                      title:
                          "One last thing.",

                      subtitle:
                          "Your birthday helps improve future financial insights.",

                      child: GestureDetector(
                        onTap: pickDate,

                        child: Container(
                          height: 60,

                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),

                            border: Border.all(
                              color:
                                  AppColors.border,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(
                                  0.02,
                                ),

                                blurRadius: 10,

                                offset:
                                    const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ],
                          ),

                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [

                              Text(
                                birthday == null
                                    ? "Select Birthday"
                                    : "${birthday!.day}/${birthday!.month}/${birthday!.year}",

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
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BUTTON
              GestureDetector(
                onTap:
                    isLoading
                        ? null
                        : nextPage,

                child: Container(
                  height: 62,

                  width:
                      double.infinity,

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
                            : Text(
                              currentPage == 2
                                  ? "Finish Setup"
                                  : "Continue",

                              style:
                                  AppTextStyles.button,
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStep({
    required String title,
    required String subtitle,
    required Widget child,
  }) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style:
                GoogleFonts.manrope(
              fontSize: 34,

              fontWeight:
                  FontWeight.w800,

              color:
                  AppColors.primary,

              letterSpacing: -1,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            subtitle,

            style:
                AppTextStyles.body,
          ),

          const SizedBox(height: 42),

          child,

          const SizedBox(height: 40),
        ],
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

      style: GoogleFonts.inter(
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
              BorderRadius.circular(18),

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

  Widget buildDropdown() {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:
              salaryFrequency,

          isExpanded: true,

          style:
              GoogleFonts.inter(
            color:
                Colors.black,

            fontSize: 15,
          ),

          items: [
            "Monthly",
            "Bi-Weekly",
            "Weekly",
          ]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),

          onChanged: (value) {

            setState(() {
              salaryFrequency =
                  value!;
            });
          },
        ),
      ),
    );
  }

  Widget buildCurrencyDropdown() {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              AppColors.border,
        ),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:
              selectedCurrency,

          isExpanded: true,

          style:
              GoogleFonts.inter(
            color:
                Colors.black,

            fontSize: 15,
          ),

          items: [
            "INR",
            "USD",
            "EUR",
            "GBP",
            "QAR",
          ]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),

          onChanged: (value) {

            setState(() {
              selectedCurrency =
                  value!;
            });
          },
        ),
      ),
    );
  }
}