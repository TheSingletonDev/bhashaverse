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

  // late SearchModel _availableASRModels;
  // SearchModel get availableASRModels => _availableASRModels;

  // late SearchModel _availableTranslationModels;
  // SearchModel get availableTranslationModels => _availableTranslationModels;

  // late SearchModel _availableTTSModels;
  // SearchModel get availableTTSModels => _availableTTSModels;

  final Map<String, dynamic> _ulcaPipelineConfig = {};
  Map<String, dynamic> get ulcaPipelineConfig => _ulcaPipelineConfig;

  void fetchULCAConfig() {
    // _availableASRModels = [];
    _translationAppAPIClient.sendULCAConfigRequest(configPayload: AppConstants.ULCA_CONFIG_PAYLOAD_FORMAT).then((response) {
      _allAvailableSourceLanguages.clear();
      _allAvailableTargetLanguages.clear();
      _ulcaPipelineConfig.clear();

      response == {}
          ? _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: false)
          : () {
              try {
                _ulcaPipelineConfig.addAll(response);
                for (var eachLangMap in ulcaPipelineConfig['languages']) {
                  _allAvailableSourceLanguages.add(
                    AppConstants.getLanguageCodeOrName(
                      value: eachLangMap['sourceLanguage'],
                      returnWhat: LANGUAGE_MAP.languageName,
                      lang_code_map: AppConstants.LANGUAGE_CODE_MAP,
                    ),
                  );
                }
                _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: true);
              } catch (e) {
                _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: false);
              }
            }();
    });
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

    String selectedSourceLanguageCode = AppConstants.getLanguageCodeOrName(
        value: selectedSourceLanguageName, returnWhat: LANGUAGE_MAP.languageCode, lang_code_map: AppConstants.LANGUAGE_CODE_MAP);

    Map<String, dynamic> targetLangListDictForSelectedSourceLangInUI =
        ulcaPipelineConfig['languages'].firstWhere((eachLangDict) => eachLangDict['sourceLanguage'] == selectedSourceLanguageCode);

    for (var eachLangCode in targetLangListDictForSelectedSourceLangInUI['targetLanguageList']) {
      _availableTargetLangsForSelectedSourceLang.add(AppConstants.getLanguageCodeOrName(
          value: eachLangCode, returnWhat: LANGUAGE_MAP.languageName, lang_code_map: AppConstants.LANGUAGE_CODE_MAP));
    }
    _appUIController.chnageAreTargetLangForSelectedSourceLangLoaded(areTargetLangForSelectedSourceLangLoaded: true);
    _appUIController.changeSourceLanguage(selectedSourceLanguageInUI: selectedSourceLanguageName);
  }
}
