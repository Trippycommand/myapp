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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomButton(
              fontSize: 12,
              borderRadius: 12,
              height: 50,
              width: screenwitdh * 0.5, 
              color: Color(0xff05E38F),
              textColor: const Color.fromARGB(255, 0, 0, 0),
              label: "Add Income",
              onPressed: () {
                // Handle income button
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              fontSize: 12,
              borderRadius: 12,
              height: 50,
              width: screenwitdh * 0.5, 
              color: Color(0xffE5F5F0),
              textColor: const Color.fromARGB(255, 0, 0, 0),
              label: "Add Income",
              onPressed: () {
                // Handle income button
              },
            ),
          ),
        ],
      ),
    );
  }
}
