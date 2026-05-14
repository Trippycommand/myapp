import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/UI component/SignUp/SignUp.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/Pages/UserSetup.dart';

class FirstUI extends StatefulWidget {
  const FirstUI({super.key});

  @override
  State<FirstUI> createState() => _FirstUIState();
}

class _FirstUIState extends State<FirstUI> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  bool isLoading = false;

  Future<void> createAccount() async {
    if (emailController.text.trim().isEmpty ||
        passController.text.trim().isEmpty ||
        nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "uid": userCredential.user!.uid,
            "createdAt": Timestamp.now(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => const UserSetup()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Signup failed"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F5),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          child: Column(
            children: [
              // TOP HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,

                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.shield_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "VaultWise",

                          style: GoogleFonts.manrope(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      height: 34,
                      width: 34,

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Icon(
                        Icons.help_outline_rounded,
                        color: AppColors.secondary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // MAIN CARD
              Container(
                padding: const EdgeInsets.all(26),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(color: Colors.grey.shade200),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Text(
                      "Create Account",

                      style: GoogleFonts.manrope(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Start managing your finances today.",

                      textAlign: TextAlign.center,

                      style: GoogleFonts.inter(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.secondary,
                      ),
                    ),

                    const SizedBox(height: 34),

                    buildField(
                      "FULL NAME",
                      "John Doe",
                      controller: nameController,
                    ),

                    const SizedBox(height: 18),

                    buildField(
                      "EMAIL ADDRESS",
                      "name@company.com",
                      controller: emailController,
                    ),

                    const SizedBox(height: 18),

                    buildField(
                      "PASSWORD",
                      "••••••••",
                      obscure: true,
                      controller: passController,
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 15,
                          color: AppColors.secondary,
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.secondary,
                                height: 1.5,
                              ),

                              children: const [
                                TextSpan(
                                  text:
                                      "Use a strong password with special characters.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Transform.scale(
                          scale: 0.9,

                          child: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            activeColor: AppColors.primary,
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 11),

                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),

                                children: const [
                                  TextSpan(text: "I agree to the "),

                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  TextSpan(text: " and Privacy Policy."),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),

                    // BUTTON
                    GestureDetector(
                      onTap: isLoading ? null : createAccount,

                      child: Container(
                        height: 58,
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.black,

                          borderRadius: BorderRadius.circular(14),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 14,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),

                        child: Center(
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    "Create Account",

                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),

                          child: Text(
                            "OR SIGN UP WITH",

                            style: GoogleFonts.inter(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: socialButton(Icons.g_mobiledata, "Google"),
                        ),

                        const SizedBox(width: 14),

                        Expanded(child: socialButton(Icons.apple, "Apple")),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Already have an account? ",

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
                          builder: (context) => const SignUpUI(),
                        ),
                      );
                    },

                    child: Text(
                      "Sign In",

                      style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
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

  Widget buildField(
    String label,
    String hint, {
    bool obscure = false,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

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
          obscureText: obscure,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: GoogleFonts.inter(
              color: AppColors.neutral,
              fontSize: 14,
            ),

            filled: true,
            fillColor: const Color(0xffFAFAFA),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),

              borderSide: BorderSide(color: AppColors.primary, width: 1.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget socialButton(IconData icon, String label) {
    return Container(
      height: 52,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icon, size: 20, color: AppColors.primary),

          const SizedBox(width: 8),

          Text(
            label,

            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
