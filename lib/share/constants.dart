import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle Appstyle(Color color, double size, FontWeight fw) {
  return GoogleFonts.poppins(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}