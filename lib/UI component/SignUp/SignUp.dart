import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';
import 'package:myapp/UI%20component/SignUp/SignUp_page_upper_part.dart';
import 'package:myapp/UI%20component/Templates/Text.dart' show CustomText;
import 'package:myapp/UI%20component/Templates/Textfeild.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignUpUI extends StatelessWidget implements PreferredSizeWidget {
  SignUpUI({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenwitdh = MediaQuery.of(context).size.width;
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
                  wordSpacing: 1, // Use a custom font if available
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: const Color.fromARGB(255, 116, 96, 96).withOpacity(0.1),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
            repeatForever: true,
            pause: const Duration(milliseconds: 1000),
          ),
          Container(
            //for textfeild
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Enter Name',
                  controller: nameController,
                ),
                CustomTextField(label: "Password", controller: passController),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Add your forgot password logic here
                        print("Forgot Password tapped!");
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
                  //For Button
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: CustomButton(
                    label: "Login",
                    onPressed: () {
                      print("Login sucessful");
                    },
                    height: 50,
                    width: screenwitdh,
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
