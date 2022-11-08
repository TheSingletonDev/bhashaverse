import 'package:flutter/material.dart';

import '../../config/app_constants.dart';

class HorizontalDivider extends StatelessWidget {
  final double horMargin;
  final double verMargin;
  final double dividerHeight;
  final double dividerBorderRad;

  const HorizontalDivider({
    Key? key,
    required this.horMargin,
    required this.verMargin,
    required this.dividerHeight,
    required this.dividerBorderRad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horMargin, vertical: verMargin),
      height: dividerHeight,
      decoration: BoxDecoration(
        color: AppConstants.STANDARD_WHITE,
        borderRadius: BorderRadius.circular(dividerBorderRad),
      ),
    );
  }
}
