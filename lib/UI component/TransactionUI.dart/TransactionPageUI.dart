import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/appbar.dart';

class TransactionPageUI extends StatefulWidget {
  const TransactionPageUI({super.key});

  @override
  State<TransactionPageUI> createState() => _TransactionPageUIState();
}

class _TransactionPageUIState extends State<TransactionPageUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5F5F0),
      appBar: const TransactionAppBar(),
      body: const Center(
        child: Text(
          'Transaction history will appear here.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );;
  }
}