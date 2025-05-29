import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInitialLeading extends StatelessWidget {
  const UserInitialLeading({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? 'User';
    final String initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFF7FCFA),
        ),
        child: Center(
          child: Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(128, 0, 150, 135),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
