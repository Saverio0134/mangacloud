import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const ColorScheme appColorScheme = ColorScheme(
  primary: Color(0xff5ccfe5),
  secondary: Color(0xff4EAD72),
  surface: Color(0xff11181e),
  tertiary: Color(0xff242b31),
  error: Colors.redAccent,
  onError: Colors.white,
  onPrimary: Color(0xff11181e),
  onSecondary: Colors.white,
  onTertiary: Colors.white,
  onSurface: Colors.white,
  brightness: Brightness.dark,
);

final appTextScheme = TextTheme(
  displaySmall: GoogleFonts.russoOne(
      fontSize: 14),
  bodySmall: GoogleFonts.russoOne(
      fontSize: 16, letterSpacing: 0),
  bodyMedium: GoogleFonts.russoOne(
      fontSize: 18, color: Colors.white),
  bodyLarge: GoogleFonts.russoOne(
      fontSize: 19, color: Colors.white),
  titleSmall: GoogleFonts.russoOne(
      fontSize: 20, letterSpacing: 0),
  titleMedium: GoogleFonts.russoOne(
      fontSize: 25, letterSpacing: 0),
  titleLarge: GoogleFonts.russoOne(
      fontSize: 38, color: Colors.white, letterSpacing: 0),
  labelSmall: GoogleFonts.roboto(
      fontSize: 12, color: Colors.white),
  labelMedium: GoogleFonts.roboto(
      fontSize: 14, color: Colors.white),
  labelLarge: GoogleFonts.roboto(
      fontSize: 16, color: Colors.white),
);