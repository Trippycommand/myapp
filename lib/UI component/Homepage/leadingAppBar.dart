import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/Pages/ProfilePage.dart';

class UserInitialLeading extends StatelessWidget {
  const UserInitialLeading({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    final String userName =
        user?.displayName ?? "User";

    final String initial =
        userName.isNotEmpty
            ? userName[0].toUpperCase()
            : "U";

    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) =>
                const ProfilePage(),
          ),
        );
      },

      child: Container(
        width: 42,
        height: 42,

        decoration:
            const BoxDecoration(
          shape: BoxShape.circle,

          color:
              Color(0xffDCE8FF),
        ),

        child: Center(
          child: Text(
            initial,

            style:
                GoogleFonts.manrope(
              color: Colors.black,

              fontWeight:
                  FontWeight.w800,

              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}