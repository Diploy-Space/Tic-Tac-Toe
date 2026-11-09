import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const bg = Color(0xFF0A0A0C);
  static const surface = Color(0xFF17171C);
  static const surface2 = Color(0xFF26262E);
  static const border = Color(0xFF2A2A33);
  static const border2 = Color(0xFF3A3A46);
  static const text = Color(0xFFF5F5F7);
  static const muted = Color(0xFFA8A8B5);
  static const magenta = Color(0xFFD4156B);
  static const pinkText = Color(0xFFD4156B);
  static const btn = Color(0xFFD4156B);
  static const teal = Color(0xFF2FB8B4);
  static const coin = Color(0xFFFFC24D);
  static const danger = Color(0xFFFF7A9A);
}

ThemeData buildTheme() {
  const deepPink = Color(0xFFD4156B);
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: C.bg,
    textTheme: GoogleFonts.outfitTextTheme(base.textTheme)
        .apply(bodyColor: C.text, displayColor: C.text),
    colorScheme: const ColorScheme.dark(
      primary: deepPink,
      secondary: C.teal,
      surface: C.surface,
      onPrimary: Colors.white,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: deepPink,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
    ),
  );
}
