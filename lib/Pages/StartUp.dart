import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/First/FirstUI.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: FirstUI()),  
    );
  }
}