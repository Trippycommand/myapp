import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/SignUp/SignUp.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color.fromARGB(180, 247, 252, 250),
      body:  SafeArea(child: SignUpUI())
      
    );
  }
}
