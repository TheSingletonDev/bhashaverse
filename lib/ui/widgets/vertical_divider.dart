import 'package:flutter/material.dart';

import '../../config/app_constants.dart';

class VerticalDivider extends StatelessWidget {
  final double horMargin;
  final double verMargin;
  final double dividerWidth;
  final double dividerBorderRad;

  const VerticalDivider({
    Key? key,
    required this.horMargin,
    required this.verMargin,
    required this.dividerWidth,
    required this.dividerBorderRad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horMargin, vertical: verMargin),
      width: dividerWidth,
      decoration: BoxDecoration(
        color: AppConstants.STANDARD_WHITE,
        borderRadius: BorderRadius.circular(dividerBorderRad),
      ),
    );
  }
}
