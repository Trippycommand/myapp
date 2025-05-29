import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Homepage/leadingAppBar.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomePageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String userName = user?.displayName ?? 'User';
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(color: Color(0xffF7FCFA)),
      ),
      title: Text(
        "Hello $userName",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      elevation: 6,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Handle profile or settings navigation
          },
        ),
      ],
leading: const UserInitialLeading() ,
    );
  }
}
