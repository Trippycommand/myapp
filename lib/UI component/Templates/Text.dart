import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/core/theme/app_theme.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      textAlign: textAlign,

      style: GoogleFonts.inter(
        fontSize: size ?? 15,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: color ?? AppColors.primary,
        height: 1.4,
      ),
    );
  }
}