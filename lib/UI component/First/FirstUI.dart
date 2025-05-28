import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Pages/SignUp.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';
import 'package:myapp/UI%20component/Templates/Text.dart';
import 'package:myapp/UI%20component/Templates/Textfeild.dart';

class FirstUI extends StatefulWidget {
  const FirstUI({super.key});

  @override
  State<FirstUI> createState() => _FirstUIState();
}

class _FirstUIState extends State<FirstUI> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> createUserWithEmailAndPassword() async {
    setState(() => _isLoading = true);
    try {
      final UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
       await userCredential.user?.updateDisplayName(nameController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Sign Up successful!"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("An unexpected error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(180, 247, 252, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(180, 247, 252, 250),
        title: const CustomText(
          text: "Sign Up",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                label: "Enter Name",
                controller: nameController,
                color: const Color(0xff479E7D),
                backgroundColor: const Color.fromARGB(180, 229, 245, 240),
              ),
              CustomTextField(
                label: "Enter Email",
                controller: emailController,
                color: const Color(0xff479E7D),
                backgroundColor: const Color.fromARGB(180, 229, 245, 240),
              ),
              CustomTextField(
                label: "Enter Password",
                controller: passwordController,
                color: const Color(0xff479E7D),
                backgroundColor: const Color.fromARGB(180, 229, 245, 240),
                obscureText: true,
              ),
              CustomTextField(
                label: "Confirm Password",
                controller: conPasswordController,
                color: const Color(0xff479E7D),
                backgroundColor: const Color.fromARGB(180, 229, 245, 240),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        label: "Sign Up",
                        onPressed: () async {
                          if (passwordController.text.trim() !=
                              conPasswordController.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Passwords do not match"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          await createUserWithEmailAndPassword();
                        },
                        height: 50,
                        width: screenWidth,
                        textColor: Colors.black,
                        color: const Color.fromARGB(255, 3, 229, 157),
                      ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: const CustomText(
                  text: "Already have an account? Sign In",
                  color: Color.fromARGB(255, 3, 229, 157),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
