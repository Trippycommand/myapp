import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userName = user?.displayName ?? 'User'; // Fallback if displayName is null
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Text(
          "Welcome, $userName!",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}
