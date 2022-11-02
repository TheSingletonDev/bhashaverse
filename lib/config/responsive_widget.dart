import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? mediumSmallScreen;
  final Widget? mediumLargeScreen;
  final Widget? smallScreen;

  const ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    this.mediumScreen,
    this.mediumSmallScreen,
    this.mediumLargeScreen,
    this.smallScreen,
  }) : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 576;
  }

  static bool isMediumSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 576 && MediaQuery.of(context).size.width <= 768;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width <= 992;
  }

  static bool isMediumLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 992 && MediaQuery.of(context).size.width <= 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 && constraints.maxWidth >= 992) {
          return mediumLargeScreen ?? largeScreen;
        } else if (constraints.maxWidth <= 992 && constraints.maxWidth >= 768) {
          return mediumScreen ?? largeScreen;
        } else if (constraints.maxWidth <= 768 && constraints.maxWidth >= 576) {
          return mediumSmallScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
