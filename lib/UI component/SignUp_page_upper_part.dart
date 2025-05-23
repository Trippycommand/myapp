import 'package:flutter/material.dart';

class GradientBox extends StatelessWidget {
  const GradientBox({super.key});

  @override
  Widget build(BuildContext context) {
    final screenwitdh = MediaQuery.of(context).size.width;
    final screenHeigh = MediaQuery.of(context).size.height;
    return Container(
      width: screenwitdh,
      height: screenHeigh * 0.30,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 46, 224, 255),
            const Color.fromARGB(255, 202, 235, 38),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      alignment: Alignment.center,
    );
  }
}
