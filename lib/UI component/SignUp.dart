import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Button.dart';
import 'package:myapp/UI%20component/SignUp_page_upper_part.dart';
import 'package:myapp/UI%20component/Text.dart' show CustomText;
import 'package:myapp/UI%20component/Textfeild.dart';
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
                'Welcome to Flutter!',
                speed: const Duration(milliseconds: 100),
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
                  padding: const EdgeInsets.only(left: 20,bottom: 10,top: 5),
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
                    onPressed: () {},
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
