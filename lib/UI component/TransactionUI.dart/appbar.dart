import 'package:flutter/material.dart';
import 'package:myapp/Pages/HomePage.dart';

class TransactionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransactionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back), // Left arrow icon
          onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context)=>HomePage())
            );
          },
        ),
      backgroundColor: const Color(0xffF7FCFA),
      elevation: 0,
      title: const Text(
        "Transactions",
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
