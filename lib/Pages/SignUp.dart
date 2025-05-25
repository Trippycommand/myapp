import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/SignUp_UI/SignUp.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  SafeArea(child: SignUpUI())
      
    );
  }
}
