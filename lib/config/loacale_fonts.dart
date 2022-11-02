import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LocaleFonts {
  static TextStyle appNameLocaleBasedFont({required Locale locale, required double fontSize}) {
    late TextStyle returningTextStyle;
    switch (locale.toString()) {
      case 'en':
        returningTextStyle = GoogleFonts.frederickaTheGreat(fontSize: fontSize);
        break;

      case 'hi':
        returningTextStyle = GoogleFonts.biryani(fontSize: fontSize * 1.3);
        break;
      default:
        returningTextStyle = GoogleFonts.frederickaTheGreat(fontSize: fontSize);
    }

    return returningTextStyle;
  }

  static TextStyle appNameSubTextLocaleBasedFont({required Locale locale, required double fontSize}) {
    late TextStyle returningTextStyle;
    switch (locale.toString()) {
      case 'en':
        returningTextStyle = GoogleFonts.frederickaTheGreat(fontSize: fontSize);
        break;

      case 'hi':
        returningTextStyle = GoogleFonts.kalam(fontSize: fontSize);
        break;
      default:
        returningTextStyle = GoogleFonts.frederickaTheGreat(fontSize: fontSize);
    }

    return returningTextStyle;
  }

  static TextStyle pageHeadingTextLocaleBasedFont({required Locale locale, required double fontSize, required FontWeight fontWeight}) {
    late TextStyle returningTextStyle;
    switch (locale.toString()) {
      case 'en':
        returningTextStyle = GoogleFonts.lobsterTwo(fontSize: fontSize, fontWeight: fontWeight);
        break;

      case 'hi':
        returningTextStyle = GoogleFonts.rozhaOne(fontSize: fontSize, fontWeight: fontWeight);
        break;
      default:
        returningTextStyle = GoogleFonts.lobsterTwo(fontSize: fontSize, fontWeight: fontWeight);
    }

    return returningTextStyle;
  }
}
