import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Pages/SignUp.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';
import 'package:myapp/UI%20component/Templates/Text.dart';
import 'package:myapp/UI%20component/Templates/Textfeild.dart';

class FirstUI extends StatefulWidget {
  FirstUI({super.key});

  @override
  State<FirstUI> createState() => _FirstUIState();
}

class _FirstUIState extends State<FirstUI> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();



  Future<void> createUserWithEmailAndPassword() async {
    try{
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print(UserCredential);
    }catch(e){
      print(e);
    }
}
  Widget build(BuildContext context) {
    final screenwitdh = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(180, 247, 252, 250),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(180, 247, 252, 250),
        title: CustomText(
          text: "SignUp",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
        centerTitle: true, // <-- this will center the title
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenwitdh * 0.03,
          right: screenwitdh * 0.03,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              CustomTextField(
                label: "Enter Name",
                controller: nameController,
                color: const Color(0xff479E7D),
                backgroundColor: Color.fromARGB(180, 229, 245, 240),
              ),
              CustomTextField(
                label: "Enter Email",
                controller: emailController,
                color: const Color(0xff479E7D),
                backgroundColor: Color.fromARGB(180, 229, 245, 240),
              ),
              CustomTextField(
                label: "Enter Password",
                controller: passwordController,
                color: const Color(0xff479E7D),
                backgroundColor: Color.fromARGB(180, 229, 245, 240),
              ),
              CustomTextField(
                label: "Confirm Password",
                controller:conPasswordController ,
                color: const Color(0xff479E7D),
                backgroundColor: Color.fromARGB(180, 229, 245, 240),
              ),
              Container(
                //For Button
                margin: EdgeInsets.only(left: 20, right: 20),
                child: CustomButton(
                  label: "Sign In",
                  onPressed: () async {
                    await createUserWithEmailAndPassword();
                  },
                  height: 50,
                  width: screenwitdh,
                  textColor: Colors.black,
                  color: const Color.fromARGB(255, 3, 229, 157),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (Context) => HomePage()),
                      );
                    },
                    child: CustomText(
                      text: "Already have an account ? Sign In ",
                      color: const Color.fromARGB(255, 3, 229, 157),
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w500,
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
}




