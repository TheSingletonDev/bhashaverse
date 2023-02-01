import 'dart:collection';
import 'package:get/get.dart';

import '../config/app_constants.dart';
import '../data/models/search_model.dart';
import '../data/translation_app_api_client.dart';
import 'app_ui_controller.dart';

class LanguageModelController extends GetxController {
  late TranslationAppAPIClient _translationAppAPIClient;
  late AppUIController _appUIController;

  @override
  void onInit() {
    super.onInit();
    _translationAppAPIClient = Get.find();
    _appUIController = Get.find();

    /*If the below method is called here in OnInit,
    it will call this method when intro page loads coz this controller is now put instead of lazyput.*/
    // calcAvailableSourceAndTargetLanguages();
  }

  final Set<String> _allAvailableSourceLanguages = {};
  Set<String> get allAvailableSourceLanguages => SplayTreeSet.from(_allAvailableSourceLanguages);

  final Set<String> _availableTargetLangsForSelectedSourceLang = {};
  Set<String> get availableTargetLangsForSelectedSourceLang => SplayTreeSet.from(_availableTargetLangsForSelectedSourceLang);

  final Set<String> _allAvailableTargetLanguages = {};
  Set<String> get allAvailableTargetLanguages => SplayTreeSet.from(_allAvailableTargetLanguages);

  late SearchModel _availableASRModels;
  SearchModel get availableASRModels => _availableASRModels;

  late SearchModel _availableTranslationModels;
  SearchModel get availableTranslationModels => _availableTranslationModels;

  late SearchModel _availableTTSModels;
  SearchModel get availableTTSModels => _availableTTSModels;

  void calcAvailableSourceAndTargetLanguages() {
    _allAvailableSourceLanguages.clear();
    _allAvailableTargetLanguages.clear();
    _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: false);

    for (String eachLangCode in AppConstants.AVAILABLE_LANGUAGES) {
      _allAvailableSourceLanguages.add(AppConstants.getLanguageCodeOrName(value: eachLangCode, returnWhat: LANGUAGE_MAP.languageName));
      _allAvailableTargetLanguages.add(AppConstants.getLanguageCodeOrName(value: eachLangCode, returnWhat: LANGUAGE_MAP.languageName));
    }
    _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: true);
  }

  void changeSelectedSourceLangAndCalcTargetLangs({required String selectedSourceLanguageName}) {
    _availableTargetLangsForSelectedSourceLang.clear();
    _appUIController.changeTargetLanguage(selectedTargetLanguageName: '');
    _appUIController.changeIsASRResponseGenerated(isASRResponseGenerated: false);
    _appUIController.changeIsTransResponseGenerated(isTransResponseGenerated: false);
    _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
    _appUIController.changeIsMaleTTSAvailable(isMaleTTSAvailable: false);
    _appUIController.changeIsFemaleTTSAvailable(isFemaleTTSAvailable: false);
    _appUIController.changeCurrentRequestStatusForUI(newStatus: AppConstants.INITIAL_CURRENT_STATUS_VALUE.tr);

    Set<String> availableTranslationModelsTargetLangForSelectedSourceLang = AppConstants.AVAILABLE_LANGUAGES
        .where((element) => AppConstants.getLanguageCodeOrName(value: element, returnWhat: LANGUAGE_MAP.languageName) != selectedSourceLanguageName)
        .toSet();

    for (String eachLangCode in availableTranslationModelsTargetLangForSelectedSourceLang) {
      _availableTargetLangsForSelectedSourceLang.add(AppConstants.getLanguageCodeOrName(value: eachLangCode, returnWhat: LANGUAGE_MAP.languageName));
    }

    _appUIController.chnageAreTargetLangForSelectedSourceLangLoaded(areTargetLangForSelectedSourceLangLoaded: true);
    _appUIController.changeSourceLanguage(selectedSourceLanguageInUI: selectedSourceLanguageName);
  }
}
