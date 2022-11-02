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
    List<dynamic> taskPayloads = [];
    for (String eachModelType in AppConstants.TYPES_OF_MODELS_LIST) {
      taskPayloads.add({"task": eachModelType, "sourceLanguage": "", "targetLanguage": "", "domain": "All", "submitter": "All", "userId": null});
    }

    _translationAppAPIClient.getAllModels(taskPayloads: taskPayloads).then((responseList) {
      _allAvailableSourceLanguages.clear();
      _allAvailableTargetLanguages.clear();
      responseList.isEmpty
          ? () {
              _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: false);
            }()
          : () {
              try {
                _availableASRModels = responseList.firstWhere((eachTaskResponse) => eachTaskResponse['taskType'] == 'asr')['modelInstance'];
                _availableTranslationModels =
                    responseList.firstWhere((eachTaskResponse) => eachTaskResponse['taskType'] == 'translation')['modelInstance'];
                _availableTTSModels = responseList.firstWhere((eachTaskResponse) => eachTaskResponse['taskType'] == 'tts')['modelInstance'];

                //Retrieve ASR Models
                Set<String> availableASRModelLanguagesSet = {};
                for (Data eachASRModel in _availableASRModels.data) {
                  availableASRModelLanguagesSet.add(eachASRModel.languages[0].sourceLanguage.toString());
                }

                //Retrieve TTS Models
                Set<String> availableTTSModelLanguagesSet = {};
                for (Data eachTTSModel in _availableTTSModels.data) {
                  availableTTSModelLanguagesSet.add(eachTTSModel.languages[0].sourceLanguage.toString());
                }

                var availableTranslationModelsList = _availableTranslationModels.data;

                if (availableASRModelLanguagesSet.isEmpty || availableTTSModelLanguagesSet.isEmpty || availableTranslationModelsList.isEmpty) {
                  throw Exception('Models not retrieved!');
                }

                Set<String> allASRAndTTSLangCombinationsSet = {};
                for (String eachASRAvailableLang in availableASRModelLanguagesSet) {
                  for (String eachTTSAvailableLang in availableTTSModelLanguagesSet) {
                    allASRAndTTSLangCombinationsSet.add('$eachASRAvailableLang-$eachTTSAvailableLang');
                  }
                }
                Set<String> availableTransModelLangCombinationsSet = {};
                for (Data eachTranslationModel in availableTranslationModelsList) {
                  availableTransModelLangCombinationsSet
                      .add('${eachTranslationModel.languages[0].sourceLanguage}-${eachTranslationModel.languages[0].targetLanguage}');
                }

                Set<String> canUseSourceAndTargetLangSet = allASRAndTTSLangCombinationsSet.intersection(availableTransModelLangCombinationsSet);

                for (String eachUseableLangPair in canUseSourceAndTargetLangSet) {
                  _allAvailableSourceLanguages.add(AppConstants.getLanguageCodeOrName(
                      value: eachUseableLangPair.split('-')[0],
                      returnWhat: LANGUAGE_MAP.languageName,
                      lang_code_map: AppConstants.LANGUAGE_CODE_MAP));
                  _allAvailableTargetLanguages.add(AppConstants.getLanguageCodeOrName(
                      value: eachUseableLangPair.split('-')[1],
                      returnWhat: LANGUAGE_MAP.languageName,
                      lang_code_map: AppConstants.LANGUAGE_CODE_MAP));
                }
                Future.delayed(const Duration(seconds: 2))
                    .then((value) => _appUIController.changeAreModelsLoadedSuccessfully(areModelsLoadedSuccessfully: true));
              } on Exception {
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

    Set<String> availableTranslationModelsTargetLangForSelectedSourceLang = {};
    var availableTranslationModelsList = _availableTranslationModels.data;

    for (var eachAvailableModel in availableTranslationModelsList) {
      if (eachAvailableModel.languages[0].sourceLanguage ==
          AppConstants.getLanguageCodeOrName(
              value: selectedSourceLanguageName, returnWhat: LANGUAGE_MAP.languageCode, lang_code_map: AppConstants.LANGUAGE_CODE_MAP)) {
        availableTranslationModelsTargetLangForSelectedSourceLang.add(AppConstants.getLanguageCodeOrName(
            value: eachAvailableModel.languages[0].targetLanguage.toString(),
            returnWhat: LANGUAGE_MAP.languageName,
            lang_code_map: AppConstants.LANGUAGE_CODE_MAP));
      }
    }

    _availableTargetLangsForSelectedSourceLang
        .addAll(availableTranslationModelsTargetLangForSelectedSourceLang.intersection(allAvailableTargetLanguages));

    _appUIController.chnageAreTargetLangForSelectedSourceLangLoaded(areTargetLangForSelectedSourceLangLoaded: true);
    _appUIController.changeSourceLanguage(selectedSourceLanguageInUI: selectedSourceLanguageName);
  }
}
