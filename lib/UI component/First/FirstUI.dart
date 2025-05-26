import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Templates/Textfeild.dart';

class FirstUI extends StatelessWidget {
  FirstUI({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenwitdh = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:Color.fromARGB(211, 247, 252, 250) ,
      appBar: AppBar(
        backgroundColor:Color(0xffF7FCFA),
        title: Text("Sign Up"),
        centerTitle: true, // <-- this will center the title
      ),
      body: Padding(
        padding: EdgeInsets.only(left:screenwitdh*0.03,right: screenwitdh*0.03),
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
              controller: nameController,
              color: const Color(0xff479E7D),
              backgroundColor: Color.fromARGB(180, 229, 245, 240)
            ),
            CustomTextField(
              label: "Enter Password",
              controller: nameController,
              color: const Color(0xff479E7D),
              backgroundColor: Color.fromARGB(180, 229, 245, 240)
            ),
            CustomTextField(
              label: "Confirm Password",
              controller: nameController,
              color: const Color(0xff479E7D),
              backgroundColor: Color.fromARGB(180, 229, 245, 240)
            ),
          ],
        ),
      ),
    );
  }
}
