import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryOrange = Color(0xFFFF6500);
  static const Color darkGrey = Color(0xFF1E1E1E);
  static const Color lightGrey = Color(0xFF323232);

  static ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      backgroundColor: const Color.fromARGB(255, 46, 62, 74),
      selectedColor: primaryOrange,
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.black),
      labelPadding: EdgeInsets.all(5),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryOrange,
      onPrimary: Colors.black,
      secondary: lightGrey,
      surface: darkGrey,
      onSurface: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: darkGrey,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGrey,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: Colors.black,
    ),
    cardTheme: const CardThemeData(
      color: lightGrey,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: primaryOrange),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: primaryOrange, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 6,
      activeTrackColor: primaryOrange,
      inactiveTrackColor: primaryOrange.withAlpha(61),
      thumbColor: lightGrey,
      overlayColor: primaryOrange.withAlpha(36),
      valueIndicatorColor: primaryOrange,
      rangeValueIndicatorShape: const PaddleRangeSliderValueIndicatorShape(),
      rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12),
    ),
  );
}
