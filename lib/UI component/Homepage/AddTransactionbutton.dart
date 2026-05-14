import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';

class Addtransactionbutton extends StatelessWidget {
  const Addtransactionbutton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
      ),

      child: Row(
        children: [

          Expanded(
            child: CustomButton(
              height: 55,
              width: screenWidth * 0.42,

              color: Colors.transparent,
              textColor: Colors.white,

              label: "Add Expense",

              onPressed: () {},
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: CustomButton(
              height: 55,
              width: screenWidth * 0.42,

              color: Colors.transparent,
              textColor: Colors.white,

              label: "Add Income",

              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}