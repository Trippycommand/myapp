import 'package:flutter/material.dart';
import 'package:myapp/UI%20component/Templates/Button.dart';

class Addtransactionbutton extends StatelessWidget {
  const Addtransactionbutton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenwitdh = MediaQuery.of(context).size.width;
    final screenHeigh = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: CustomButton(
              height: 50,
              width: screenwitdh * 0.4, 
              color: Colors.green,
              textColor: Colors.white,
              label: "Add Income",
              onPressed: () {
                // Handle income button
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              label: "Add Expense",
              onPressed: () {
                // Handle expense button
              },
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
