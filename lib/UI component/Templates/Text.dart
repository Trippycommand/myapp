import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;

  const CustomText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 16,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
