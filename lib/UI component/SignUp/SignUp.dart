import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Pages/HomePage.dart';
import 'package:myapp/UI component/First/FirstUI.dart';
import 'package:myapp/core/theme/app_theme.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({super.key});

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passController =
      TextEditingController();

  Future<void> loginUser() async {
    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Login failed",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),

          child: Column(
            children: [

              // TOP BAR
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Row(
                    children: [

                      Text(
                        "security",

                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "VaultWise",

                        style: GoogleFonts.manrope(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [

                      Icon(
                        Icons.verified_user_outlined,
                        size: 16,
                        color: AppColors.secondary,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "SECURED",

                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 45),

              // MAIN CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(20),

                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    // LOCK ICON
                    Container(
                      height: 68,
                      width: 68,

                      decoration: BoxDecoration(
                        color: const Color(0xffDCE8FF),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.lock,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Text(
                      "Welcome Back",

                      style: GoogleFonts.manrope(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Sign in to manage your high-precision vault\nand assets.",

                      textAlign: TextAlign.center,

                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(height: 34),

                    // EMAIL
                    buildField(
                      label: "EMAIL ADDRESS",
                      hint: "name@company.com",
                      icon: Icons.email_outlined,
                      controller: emailController,
                    ),

                    const SizedBox(height: 20),

                    // PASSWORD
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Text(
                              "PASSWORD",

                              style:
                                  GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    AppColors.secondary,
                                letterSpacing: 0.8,
                              ),
                            ),

                            Text(
                              "Forgot Password?",

                              style:
                                  GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w700,
                                color:
                                    Colors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: passController,
                          obscureText: true,

                          decoration: InputDecoration(
                            hintText: "••••••••",

                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),

                            suffixIcon: const Icon(
                              Icons.remove_red_eye_outlined,
                            ),

                            filled: true,
                            fillColor:
                                const Color(0xffFAFAFA),

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),

                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(10),

                              borderSide: BorderSide(
                                color: Colors
                                    .grey.shade300,
                              ),
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(10),

                              borderSide: BorderSide(
                                color: Colors
                                    .grey.shade300,
                              ),
                            ),

                            focusedBorder:
                                const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(
                                Radius.circular(10),
                              ),

                              borderSide: BorderSide(
                                color:
                                    AppColors.primary,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // LOGIN BUTTON
                    GestureDetector(
                      onTap: loginUser,

                      child: Container(
                        height: 58,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: const Color(0xff149A90),

                          borderRadius:
                              BorderRadius.circular(12),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xff149A90,
                              ).withOpacity(0.25),

                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),

                        child: Center(
                          child: Text(
                            "Sign In",

                            style:
                                GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Row(
                      children: [

                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),

                          child: Text(
                            "OR CONTINUE WITH",

                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  AppColors.secondary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [

                        Expanded(
                          child: socialButton(
                            Icons.g_mobiledata,
                            "Google",
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: socialButton(
                            Icons.apple,
                            "Apple",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // SIGN UP
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Text(
                    "Don't have an account? ",

                    style: GoogleFonts.inter(
                      color: AppColors.secondary,
                      fontSize: 14,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FirstUI(),
                        ),
                      );
                    },

                    child: Text(
                      "Sign Up",

                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Divider(
                color: Colors.grey.shade300,
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,

                children: [

                  footerItem(
                    Icons.verified_user_outlined,
                    "ISO 27001 CERTIFIED",
                  ),

                  footerItem(
                    Icons.shield_outlined,
                    "256-BIT ENCRYPTION",
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Text(
                    "Privacy Policy",

                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Text(
                    "Terms of Service",

                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          label,

          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controller,

          decoration: InputDecoration(
            hintText: hint,

            prefixIcon: Icon(icon),

            filled: true,
            fillColor: const Color(0xffFAFAFA),

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),

              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10),

              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),

            focusedBorder:
                const OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(
                Radius.circular(10),
              ),

              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget socialButton(
    IconData icon,
    String label,
  ) {
    return Container(
      height: 54,

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 20,
          ),

          const SizedBox(width: 8),

          Text(
            label,

            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget footerItem(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [

        Icon(
          icon,
          size: 14,
          color: AppColors.secondary,
        ),

        const SizedBox(width: 6),

        Text(
          text,

          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}