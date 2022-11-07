import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationController extends GetxController {
  String _currentSelectedLang = GetStorage().read('userSelectedLang');
  String get getCurrentSelectedLocalizationLangInUI => _currentSelectedLang;

  void changeCurrentSelectedLocalizationLangInUI(String currentSelectedLang) {
    _currentSelectedLang = currentSelectedLang;
    update();
  }

  void changeLocalization({required String newLocale}) {
    Get.updateLocale(Locale(newLocale));
  }
}
