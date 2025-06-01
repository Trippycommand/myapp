import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/appbar.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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
    );
  }
}
