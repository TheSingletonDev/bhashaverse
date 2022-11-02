import 'package:flutter/widgets.dart';

class SizeConfig {
  final BuildContext context;
  late final MediaQueryData _mediaQueryData;
  late final double _screenWidth;
  late final double _screenHeight;
  static double blockSizeHorizontal = 1;
  static double blockSizeVertical = 1;

  SizeConfig({required this.context}) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = _screenWidth / 100;
    blockSizeVertical = _screenHeight / 100;
  }
}
