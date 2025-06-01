import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';
import 'package:myapp/UI%20component/SignUp/SignUp_page_upper_part.dart';
import 'package:myapp/UI%20component/Templates/Text.dart' show CustomText;
import 'package:myapp/UI%20component/Templates/Textfeild.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:myapp/Pages/HomePage.dart'; // Make sure this path is correct

class SignUpUI extends StatefulWidget implements PreferredSizeWidget {
  const SignUpUI({super.key});

  @override
  State<SignUpUI> createState() => _SignUpUIState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SignUpUIState extends State<SignUpUI> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  Future<void> loginUser() async {
    try {
      // ignore: unused_local_variable
      final userCredential= FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          const GradientBox(),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Welcome to PayTrack',
                speed: const Duration(milliseconds: 100),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 13, 236, 210),
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: const Color.fromARGB(255, 116, 96, 96).withOpacity(0.1),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
            repeatForever: true,
            pause: const Duration(milliseconds: 1000),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Enter Email',
                  controller: emailController,
                  color: const Color.fromARGB(255, 94, 200, 149),
                  backgroundColor: const Color.fromARGB(180, 229, 245, 240),
                ),
                CustomTextField(
                  label: "Password",
                  controller: passController,
                  color: const Color.fromARGB(255, 94, 200, 149),
                  backgroundColor: const Color.fromARGB(180, 229, 245, 240),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        print("Forgot Password tapped!");
                        // Optionally implement forgot password
                      },
                      child: CustomText(
                        text: "Forgot Password ?",
                        color: const Color.fromARGB(255, 3, 229, 157),
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: CustomButton(
                    label: "Login",
                    onPressed: loginUser,
                    height: 50,
                    width: screenWidth,
                    textColor: Colors.black,
                    color: const Color.fromARGB(255, 3, 229, 157),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
