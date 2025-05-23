import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/SignUp.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  SafeArea(child: SignUpUI())
      
    );
  }
}
