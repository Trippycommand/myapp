import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/SignUp_page_upper_part.dart';
import 'package:myapp/UI%20component/Textfeild.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignUpUI extends StatelessWidget implements PreferredSizeWidget {
  SignUpUI({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CustomTextField(label: 'Enter Name', controller: nameController),
              CustomTextField(label: "Password", controller: passController),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
