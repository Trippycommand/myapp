import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

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
          "Profile",

          style:
              GoogleFonts.manrope(
            color:
                AppColors.primary,

            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .get(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              !snapshot.data!.exists) {

            return const Center(
              child:
                  Text("No profile data"),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          final name =
              data["name"] ?? "User";

          final email =
              data["email"] ?? "";

          final company =
              data["companyName"] ?? "";

          final job =
              data["jobTitle"] ?? "";

          final income =
              data["monthlyIncome"] ?? 0;

          final goal =
              data["financialGoal"] ?? "";

          final currency =
              data["currency"] ?? "INR";

          return SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              children: [

                const SizedBox(height: 10),

                // PROFILE CARD
                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      28,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.04,
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

                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 42,

                        backgroundColor:
                            AppColors.primary,

                        child: Text(
                          name[0]
                              .toUpperCase(),

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontSize: 32,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      Text(
                        name,

                        style:
                            GoogleFonts.manrope(
                          fontSize: 28,

                          fontWeight:
                              FontWeight.w800,

                          color:
                              AppColors.primary,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        email,

                        style:
                            AppTextStyles.body,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                buildInfoCard(
                  "Company",
                  company,
                ),

                buildInfoCard(
                  "Job Title",
                  job,
                ),

                buildInfoCard(
                  "Monthly Salary",
                  "$currency $income",
                ),

                buildInfoCard(
                  "Financial Goal",
                  goal,
                ),

                const SizedBox(height: 20),

                // EDIT BUTTON
                SizedBox(
                  width:
                      double.infinity,

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xffEEF0FF),

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    onPressed: () {

                      showModalBottomSheet(
                        context: context,

                        isScrollControlled:
                            true,

                        backgroundColor:
                            Colors.white,

                        shape:
                            const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(
                            top:
                                Radius.circular(
                              28,
                            ),
                          ),
                        ),

                        builder: (_) {

                          final companyController =
                              TextEditingController(
                            text:
                                company,
                          );

                          final jobController =
                              TextEditingController(
                            text:
                                job,
                          );

                          final incomeController =
                              TextEditingController(
                            text:
                                income.toString(),
                          );

                          final goalController =
                              TextEditingController(
                            text:
                                goal,
                          );

                          return Padding(
                            padding:
                                EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 24,

                              bottom:
                                  MediaQuery.of(
                                            context,
                                          )
                                          .viewInsets
                                          .bottom +
                                      24,
                            ),

                            child:
                                SingleChildScrollView(
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min,

                                children: [

                                  Text(
                                    "Edit Profile",

                                    style:
                                        GoogleFonts.manrope(
                                      fontSize:
                                          28,

                                      fontWeight:
                                          FontWeight
                                              .w800,

                                      color:
                                          AppColors
                                              .primary,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 28,
                                  ),

                                  buildEditField(
                                    "Company",
                                    companyController,
                                  ),

                                  const SizedBox(
                                    height: 18,
                                  ),

                                  buildEditField(
                                    "Job Title",
                                    jobController,
                                  ),

                                  const SizedBox(
                                    height: 18,
                                  ),

                                  buildEditField(
                                    "Monthly Salary",
                                    incomeController,
                                    isNumber:
                                        true,
                                  ),

                                  const SizedBox(
                                    height: 18,
                                  ),

                                  buildEditField(
                                    "Financial Goal",
                                    goalController,
                                  ),

                                  const SizedBox(
                                    height: 28,
                                  ),

                                  SizedBox(
                                    width:
                                        double
                                            .infinity,

                                    child:
                                        ElevatedButton(
                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors
                                                .primary,

                                        padding:
                                            const EdgeInsets.symmetric(
                                          vertical:
                                              18,
                                        ),

                                        shape:
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),

                                      onPressed:
                                          () async {

                                        await FirebaseFirestore
                                            .instance
                                            .collection(
                                              "users",
                                            )
                                            .doc(
                                              user.uid,
                                            )
                                            .update({

                                          "companyName":
                                              companyController.text.trim(),

                                          "jobTitle":
                                              jobController.text.trim(),

                                          "monthlyIncome":
                                              int.tryParse(
                                                    incomeController.text,
                                                  ) ??
                                                  0,

                                          "financialGoal":
                                              goalController.text.trim(),
                                        });

                                        if (!mounted) return;

                                        Navigator.pop(
                                          context,
                                        );

                                        setState(() {});
                                      },

                                      child:
                                          const Text(
                                        "Save Changes",
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

                    child: const Text(
                      "Edit Profile",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildInfoCard(
    String title,
    String value,
  ) {

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
            Colors.white,

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.03,
            ),

            blurRadius: 10,

            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,

            style:
                GoogleFonts.inter(
              fontSize: 14,

              color:
                  AppColors.secondary,
            ),
          ),

          Flexible(
            child: Text(
              value,

              textAlign:
                  TextAlign.right,

              style:
                  GoogleFonts.manrope(
                fontSize: 16,

                fontWeight:
                    FontWeight.w700,

                color:
                    AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEditField(
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