import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {

  // PRIMARY DESIGN COLORS
  static const Color primary =
      Color(0xff0F172A);

  static const Color secondary =
      Color(0xff64748B);

  static const Color tertiary =
      Color(0xff231500);

  static const Color neutral =
      Color(0xff787878);

  // BACKGROUNDS
  static const Color background =
      Color(0xffF4F4F5);

  static const Color card =
      Colors.white;

  // STATUS COLORS
  static const Color success =
      Color(0xff149A90);

  static const Color error =
      Color(0xffDC2626);

  static const Color warning =
      Color(0xffD97706);

  // BORDERS
  static const Color border =
      Color(0xffE4E4E7);
}

class AppTextStyles {

  // MAIN PAGE TITLES
  static final heading =
      GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: -1,
  );

  // CARD TITLES
  static final subHeading =
      GoogleFonts.manrope(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // BODY TEXT
  static final body =
      GoogleFonts.inter(
    fontSize: 15,
    height: 1.5,
    color: AppColors.secondary,
  );

  // SMALL LABELS
  static final label =
      GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.secondary,
    letterSpacing: 0.5,
  );

  // BUTTONS
  static final button =
      GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // BALANCE / MONEY
  static final amount =
      GoogleFonts.manrope(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: -1,
  );
}