import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_constants.dart';

class SnackBarFormattedText extends StatelessWidget {
  final String text;
  final GETX_SNACK_BAR titleOrMessage;

  const SnackBarFormattedText({
    Key? key,
    required this.text,
    required this.titleOrMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = titleOrMessage == GETX_SNACK_BAR.title
        ? GoogleFonts.kodchasan(color: AppConstants.STANDARD_WHITE, fontSize: 30.w, fontWeight: FontWeight.w700)
        : GoogleFonts.comfortaa(color: AppConstants.STANDARD_WHITE, fontSize: 20.w);
    return AutoSizeText(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle);
  }
}

class SnackBarFormattedIcon extends StatelessWidget {
  const SnackBarFormattedIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.error_outline_rounded,
      color: AppConstants.STANDARD_WHITE,
      size: 30.w,
    );
  }
}

void showSnackbar({required String title, required String message}) {
  Get.snackbar(
    '',
    '',
    titleText: SnackBarFormattedText(
      text: title,
      titleOrMessage: GETX_SNACK_BAR.title,
    ),
    messageText: SnackBarFormattedText(
      text: message,
      titleOrMessage: GETX_SNACK_BAR.message,
    ),
    icon: const SnackBarFormattedIcon(),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppConstants.STANDARD_BLACK.withOpacity(0.2),
    borderRadius: 10.w,
    margin: EdgeInsets.all(20.w),
    barBlur: 40,
    overlayColor: AppConstants.STANDARD_BLACK.withOpacity(0.80),
    overlayBlur: 1,
    colorText: AppConstants.STANDARD_WHITE,
    duration: const Duration(seconds: 4),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
