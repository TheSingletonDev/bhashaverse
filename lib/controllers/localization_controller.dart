import 'dart:ui';

import 'package:get/get.dart';

class LocalizationController extends GetxController {
  String _currentSelectedLang = 'English';
  String get getCurrentSelectedLocalizationLangInUI => _currentSelectedLang;
  void changeCurrentSelectedLocalizationLangInUI(String currentSelectedLang) {
    _currentSelectedLang = currentSelectedLang;
    update();
  }

  void changeLocalization({required String newLocale}) {
    Get.updateLocale(Locale(newLocale));
  }
}
