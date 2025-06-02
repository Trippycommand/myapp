import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/TransactionPageUI.dart';
import 'package:myapp/UI%20component/TransactionUI.dart/appbar.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return TransactionPageUI();
  }
}
