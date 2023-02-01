import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import '../config/app_constants.dart';
import '../data/translation_app_api_client.dart';
import 'app_ui_controller.dart';
import 'hardware_requests_controller.dart';

class SpeechToSpeechController extends GetxController {
  late AppUIController _appUIController;
  late HardwareRequestsController _hardwareRequestsController;
  late TranslationAppAPIClient _translationAppAPIClient;

  late String _asrResponseText;
  String get asrResponseText => _asrResponseText;

  late String _transResponseText;
  String get transResponseText => _transResponseText;

  String _ttsMaleAudioFilePath = '';
  String get ttsMaleAudioFilePath => _ttsMaleAudioFilePath;

  String _ttsFemaleAudioFilePath = '';
  String get ttsFemaleAudioFilePath => _ttsFemaleAudioFilePath;

  @override
  void onInit() {
    super.onInit();
    _appUIController = Get.find();
    _hardwareRequestsController = Get.find();
    _translationAppAPIClient = Get.find();
  }

  /*Or can do 2 separate functions. One with async-await and await all methods instead of .then() and then call
  this new method in non-future type method with .then() appearing once!*/

  void sendSpeechToSpeechRequests({required String base64AudioContent}) {
    // _sendSpeechToSpeechRequestsInternal(base64AudioContent: base64AudioContent).then((_) {});
    _getS2SOutputForBothGender(base64AudioContent: base64AudioContent).then((_) {});
  }

  Future _getS2SOutputForBothGender({required String base64AudioContent}) async {
    try {
      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: true);
      _appUIController.changeHasS2SRequestInitiated(hasS2SRequestInitiated: true);

      String selectedSourceLangCodeInUI =
          AppConstants.getLanguageCodeOrName(value: _appUIController.selectedSourceLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

      String selectedTargetLangCodeInUI =
          AppConstants.getLanguageCodeOrName(value: _appUIController.selectedTargetLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

      _appUIController.changeCurrentRequestStatusForUI(
          newStatus: AppConstants.S2S_REQ_STATUS_MSG.tr
              .replaceFirst('%replaceContent%', '${_appUIController.selectedSourceLangNameInUI}-${_appUIController.selectedTargetLangNameInUI}'));

      //Below two lines so that any changes are made to a new map, not the original format
      // var s2sPayloadToSendForMale = {};
      Map<String, dynamic> s2sPayloadToSendForMale = {
        "serviceId": "",
        "audio": [
          {"audioContent": ""}
        ],
        "config": {
          "language": {"sourceLanguage": "", "targetLanguage": ""},
          "gender": "male"
        }
      };
      Map<String, dynamic> s2sPayloadToSendForFemale = {
        "serviceId": "",
        "audio": [
          {"audioContent": ""}
        ],
        "config": {
          "language": {"sourceLanguage": "", "targetLanguage": ""},
          "gender": "female"
        }
      };

      s2sPayloadToSendForMale['serviceId'] = '';
      s2sPayloadToSendForMale['audio'][0]['audioContent'] = base64AudioContent;
      s2sPayloadToSendForMale['config']['language']['sourceLanguage'] = selectedSourceLangCodeInUI;
      s2sPayloadToSendForMale['config']['language']['targetLanguage'] = selectedTargetLangCodeInUI;

      s2sPayloadToSendForFemale['serviceId'] = '';
      s2sPayloadToSendForFemale['audio'][0]['audioContent'] = base64AudioContent;
      s2sPayloadToSendForFemale['config']['language']['sourceLanguage'] = selectedSourceLangCodeInUI;
      s2sPayloadToSendForFemale['config']['language']['targetLanguage'] = selectedTargetLangCodeInUI;

      List<Map<String, dynamic>> responseList =
          await _translationAppAPIClient.sendS2SReqForBothGender(s2sPayloadList: [s2sPayloadToSendForMale, s2sPayloadToSendForFemale]);

      if (responseList.isNotEmpty) {
        String s2sMaleAudioBase64String = responseList[0]['output']['audio'][0]['audioContent'] ?? '';
        String s2sFemaleAudioBase64String = responseList[1]['output']['audio'][0]['audioContent'] ?? '';

        await _hardwareRequestsController.requestPermissions();
        String appDocPath = await _hardwareRequestsController.getAppDirPath();

        _asrResponseText = responseList[0]['output']['output'][0]['source'];
        _appUIController.changeIsASRResponseGenerated(isASRResponseGenerated: true);

        _transResponseText = responseList[0]['output']['output'][0]['target'];
        _appUIController.changeIsTransResponseGenerated(isTransResponseGenerated: true);

        if (s2sMaleAudioBase64String.isNotEmpty) {
          var maleFileAsBytes = base64Decode(s2sMaleAudioBase64String);
          String maleTTSAudioFileName = '$appDocPath/TTSMaleAudio.wav';
          final maleAudioFile = File(maleTTSAudioFileName);
          await maleAudioFile.writeAsBytes(maleFileAsBytes);
          _ttsMaleAudioFilePath = maleTTSAudioFileName;
          _appUIController.changeIsMaleTTSAvailable(isMaleTTSAvailable: true);
        }

        if (s2sFemaleAudioBase64String.isNotEmpty) {
          var femaleFileAsBytes = base64Decode(s2sFemaleAudioBase64String);
          String femaleTTSAudioFileName = '$appDocPath/TTSFemaleAudio.wav';
          final femaleAudioFile = File(femaleTTSAudioFileName);
          await femaleAudioFile.writeAsBytes(femaleFileAsBytes);
          _ttsFemaleAudioFilePath = femaleTTSAudioFileName;
          _appUIController.changeIsFemaleTTSAvailable(isFemaleTTSAvailable: true);
        }

        _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
        _appUIController.changeHasSpeechToSpeechUpdateRequestsInitiated(hasSpeechToSpeechUpdateRequestsInitiated: false); // Only for Update Button

        _appUIController.changeHasS2SRequestInitiated(hasS2SRequestInitiated: false);

        if (_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
          _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
          _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
        } else if (_appUIController.isMaleTTSAvailable && !_appUIController.isFemaleTTSAvailable) {
          _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
          _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.male);
        } else if (!_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
          _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
          _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
        } else {
          _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
        }
      }
    } on Exception {
      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
      _appUIController.changeHasSpeechToSpeechUpdateRequestsInitiated(hasSpeechToSpeechUpdateRequestsInitiated: false); //Only for Update Button
      _appUIController.changeHasS2SRequestInitiated(hasS2SRequestInitiated: false);
      _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
    }
  }

  // Future _sendSpeechToSpeechRequestsInternal({required String base64AudioContent}) async {
  //   try {
  //     _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: true);
  //     _appUIController.changeCurrentRequestStatusForUI(
  //         newStatus: AppConstants.SPEECH_RECG_REQ_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));

  //     var asrOutputString = await _getASROutput(base64AudioContent: base64AudioContent);

  //     if (asrOutputString.isEmpty) {
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.SPEECH_RECG_FAIL_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));
  //       throw Exception(MODEL_TYPES.ASR);
  //     }

  //     _asrResponseText = asrOutputString;

  //     _appUIController.changeIsASRResponseGenerated(isASRResponseGenerated: true);
  //     _appUIController.changeCurrentRequestStatusForUI(
  //         newStatus: AppConstants.SPEECH_RECG_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));

  //     //Simulated delay of xx seconds for UX
  //     await Future.delayed(const Duration(seconds: 1));

  //     _appUIController.changeCurrentRequestStatusForUI(
  //         newStatus: AppConstants.SEND_TRANS_REQ_STATUS_MSG.tr
  //             .toString()
  //             .replaceFirst('%replaceContent1%', _appUIController.selectedSourceLangNameInUI)
  //             .replaceFirst('%replaceContent2%', _appUIController.selectedTargetLangNameInUI));

  //     var transOutputString = await _getTranslationOutput(asrOutputAsTransInputString: asrOutputString);
  //     if (transOutputString.isEmpty) {
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.TRANS_FAIL_STATUS_MSG.tr
  //               .toString()
  //               .replaceFirst('%replaceContent1%', _appUIController.selectedSourceLangNameInUI)
  //               .replaceFirst('%replaceContent2%', _appUIController.selectedTargetLangNameInUI));
  //       throw Exception(MODEL_TYPES.TRANSLATION);
  //     }

  //     _transResponseText = transOutputString;
  //     _appUIController.changeIsTransResponseGenerated(isTransResponseGenerated: true);
  //     _appUIController.changeCurrentRequestStatusForUI(
  //         newStatus: AppConstants.TRANS_SUCCESS_STATUS_MSG.tr
  //             .toString()
  //             .replaceFirst('%replaceContent1%', _appUIController.selectedSourceLangNameInUI)
  //             .replaceFirst('%replaceContent2%', _appUIController.selectedTargetLangNameInUI));

  //     await Future.delayed(const Duration(seconds: 1));

  //     _appUIController.changeCurrentRequestStatusForUI(
  //         newStatus: AppConstants.SEND_TTS_REQ_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
  //     _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: true);

  //     var ttsResponseList = await _getTTSOutputForBothGender(transOutputAsTTSInputString: transOutputString);

  //     if (ttsResponseList.isEmpty) {
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.TTS_FAIL_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
  //       throw Exception(MODEL_TYPES.TTS);
  //     }

  //     await _hardwareRequestsController.requestPermissions();
  //     String appDocPath = await _hardwareRequestsController.getAppDirPath();

  //     var ttsMaleOutputBase64String = ttsResponseList[0];
  //     var ttsFemaleOutputBase64String = ttsResponseList[1];

  //     if (ttsMaleOutputBase64String.isNotEmpty) {
  //       var maleFileAsBytes = base64Decode(ttsMaleOutputBase64String);
  //       String maleTTSAudioFileName = '$appDocPath/TTSMaleAudio.wav';
  //       final maleAudioFile = File(maleTTSAudioFileName);
  //       await maleAudioFile.writeAsBytes(maleFileAsBytes);
  //       _ttsMaleAudioFilePath = maleTTSAudioFileName;
  //       _appUIController.changeIsMaleTTSAvailable(isMaleTTSAvailable: true);
  //     }

  //     if (ttsFemaleOutputBase64String.isNotEmpty) {
  //       var femaleFileAsBytes = base64Decode(ttsFemaleOutputBase64String);
  //       String femaleTTSAudioFileName = '$appDocPath/TTSFemaleAudio.wav';
  //       final femaleAudioFile = File(femaleTTSAudioFileName);
  //       await femaleAudioFile.writeAsBytes(femaleFileAsBytes);
  //       _ttsFemaleAudioFilePath = femaleTTSAudioFileName;
  //       _appUIController.changeIsFemaleTTSAvailable(isFemaleTTSAvailable: true);
  //     }

  //     _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
  //     _appUIController.changeHasSpeechToSpeechUpdateRequestsInitiated(hasSpeechToSpeechUpdateRequestsInitiated: false); // Only for Update Button

  //     _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: false);

  //     if (_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
  //       _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
  //       _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
  //     } else if (_appUIController.isMaleTTSAvailable && !_appUIController.isFemaleTTSAvailable) {
  //       _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
  //       _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.male);
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
  //     } else if (!_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
  //       _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
  //       _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
  //     } else {
  //       _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
  //       _appUIController.changeCurrentRequestStatusForUI(
  //           newStatus: AppConstants.TTS_FAIL_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
  //     }
  //   } on Exception {
  //     _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
  //     _appUIController.changeHasSpeechToSpeechUpdateRequestsInitiated(hasSpeechToSpeechUpdateRequestsInitiated: false); //Only for Update Button
  //     _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: false);
  //     _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
  //   }
  // }

  // Future<String> _getASROutput({required String base64AudioContent}) async {
  //   List<String> availableASRModelsForSelectedLangInUIDefault = [];
  //   List<String> availableASRModelsForSelectedLangInUI = [];
  //   bool isAtLeastOneDefaultModelTypeFound = false;
  //   String selectedSourceLangCodeInUI =
  //       AppConstants.getLanguageCodeOrName(value: _appUIController.selectedSourceLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

  //   String serviceId = '';
  //   for (var eachMap in AppConstants.ASR_SERVICE_ID_MAP) {
  //     if (selectedSourceLangCodeInUI == eachMap['languageCode']) {
  //       serviceId = eachMap['serviceId']!;
  //     }
  //   }

  //   //Below two lines so that any changes are made to a new map, not the original format
  //   var asrPayloadToSend = {};
  //   asrPayloadToSend.addAll(AppConstants.ASR_PAYLOAD_FORMAT);

  //   //print('ASR Model ID used- https://bhashini.gov.in/ulca/search-model/$asrModelIDToUse');

  //   asrPayloadToSend['serviceId'] = serviceId;
  //   asrPayloadToSend['audio'][0]['audioContent'] = base64AudioContent;
  //   asrPayloadToSend['config']['language']['sourceLanguage'] = selectedSourceLangCodeInUI;

  //   Map<dynamic, dynamic> response = await _translationAppAPIClient.sendASRRequest(asrPayload: asrPayloadToSend);
  //   if (response.isEmpty) {
  //     return '';
  //   }

  //   return response['source'];
  // }

  // Future<String> _getTranslationOutput({required String asrOutputAsTransInputString}) async {
  //   List<String> availableTransModelsForSelectedLangInUIDefault = [];
  //   List<String> availableTransModelsForSelectedLangInUI = [];
  //   bool isAtLeastOneDefaultModelTypeFound = false;
  //   String selectedSourceLangCodeInUI =
  //       AppConstants.getLanguageCodeOrName(value: _appUIController.selectedSourceLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

  //   String selectedTargetLangCodeInUI =
  //       AppConstants.getLanguageCodeOrName(value: _appUIController.selectedTargetLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

  //   List<String> availableSubmittersList = [];
  //   for (var eachAvailableTransModelData in _languageModelController.availableTranslationModels.data) {
  //     if (eachAvailableTransModelData.languages[0].sourceLanguage == selectedSourceLangCodeInUI &&
  //         eachAvailableTransModelData.languages[0].targetLanguage == selectedTargetLangCodeInUI) {
  //       if (!availableSubmittersList.contains(eachAvailableTransModelData.name.toLowerCase())) {
  //         availableSubmittersList.add(eachAvailableTransModelData.name.toLowerCase());
  //       }
  //     }
  //   }
  //   availableSubmittersList = availableSubmittersList.toSet().toList();

  //   //Check AI4Bharat model availability
  //   String ai4BharatModelName = '';
  //   for (var eachSubmitter in availableSubmittersList) {
  //     if (eachSubmitter.toLowerCase().contains(AppConstants.DEFAULT_MODEL_TYPES[AppConstants.TYPES_OF_MODELS_LIST[1]]!.split(',')[0].toLowerCase())) {
  //       ai4BharatModelName = eachSubmitter;
  //     }
  //   }

  //   if (ai4BharatModelName.isNotEmpty) {
  //     for (var eachAvailableTransModelData in _languageModelController.availableTranslationModels.data) {
  //       if (eachAvailableTransModelData.name.toLowerCase() == ai4BharatModelName.toLowerCase()) {
  //         availableTransModelsForSelectedLangInUIDefault.add(eachAvailableTransModelData.modelId);
  //         isAtLeastOneDefaultModelTypeFound = true;
  //       }
  //     }
  //   } else {
  //     for (var eachAvailableTransModelData in _languageModelController.availableTranslationModels.data) {
  //       if (eachAvailableTransModelData.languages[0].sourceLanguage == selectedSourceLangCodeInUI &&
  //           eachAvailableTransModelData.languages[0].targetLanguage == selectedTargetLangCodeInUI) {
  //         availableTransModelsForSelectedLangInUI.add(eachAvailableTransModelData.modelId);
  //       }
  //     }
  //   }

  //   //Either select default model (vakyansh for now) or any random model from the available list.
  //   String transModelIDToUse = isAtLeastOneDefaultModelTypeFound
  //       ? availableTransModelsForSelectedLangInUIDefault[Random().nextInt(availableTransModelsForSelectedLangInUIDefault.length)]
  //       : availableTransModelsForSelectedLangInUI[Random().nextInt(availableTransModelsForSelectedLangInUI.length)];

  //   //Below two lines so that any changes are made to a new map, not the original format
  //   var transPayloadToSend = {};
  //   transPayloadToSend.addAll(AppConstants.TRANS_PAYLOAD_FORMAT);

  //   //print('Translation Model ID used: https://bhashini.gov.in/ulca/search-model/$transModelIDToUse');

  //   transPayloadToSend['modelId'] = transModelIDToUse;
  //   transPayloadToSend['task'] = AppConstants.TYPES_OF_MODELS_LIST[1];
  //   transPayloadToSend['input'][0]['source'] = asrOutputAsTransInputString;

  //   Map<dynamic, dynamic> response = await _translationAppAPIClient.sendTranslationRequest(transPayload: transPayloadToSend);
  //   if (response.isEmpty) {
  //     return '';
  //   }
  //   return response['output'][0]['target'];
  // }

  // Future<List<String>> _getTTSOutputForBothGender({required String transOutputAsTTSInputString}) async {
  //   List<String> availableTTSModelsForSelectedLangInUIDefault = [];
  //   List<String> availableTTSModelsForSelectedLangInUI = [];
  //   bool isAtLeastOneDefaultModelTypeFound = false;
  //   String selectedTargetLangCodeInUI =
  //       AppConstants.getLanguageCodeOrName(value: _appUIController.selectedTargetLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

  //   List<String> availableSubmittersList = [];
  //   for (var eachAvailableTTSModelData in _languageModelController.availableTTSModels.data) {
  //     if (eachAvailableTTSModelData.languages[0].sourceLanguage == selectedTargetLangCodeInUI) {
  //       if (!availableSubmittersList.contains(eachAvailableTTSModelData.name.toLowerCase())) {
  //         availableSubmittersList.add(eachAvailableTTSModelData.name.toLowerCase());
  //       }
  //     }
  //   }
  //   availableSubmittersList = availableSubmittersList.toSet().toList();

  //   //Check AI4Bharat model availability
  //   String ai4BharatModelName = '';
  //   for (var eachSubmitter in availableSubmittersList) {
  //     if (eachSubmitter.toLowerCase().contains(AppConstants.DEFAULT_MODEL_TYPES[AppConstants.TYPES_OF_MODELS_LIST[2]]!.split(',')[0].toLowerCase())) {
  //       ai4BharatModelName = eachSubmitter;
  //     }
  //   }

  //   if (ai4BharatModelName.isNotEmpty) {
  //     for (var eachAvailableTTSModelData in _languageModelController.availableTTSModels.data) {
  //       if (eachAvailableTTSModelData.name.toLowerCase() == ai4BharatModelName.toLowerCase()) {
  //         availableTTSModelsForSelectedLangInUIDefault.add(eachAvailableTTSModelData.modelId);
  //         isAtLeastOneDefaultModelTypeFound = true;
  //       }
  //     }
  //   } else {
  //     for (var eachAvailableTTSModelData in _languageModelController.availableTTSModels.data) {
  //       if (eachAvailableTTSModelData.languages[0].sourceLanguage == selectedTargetLangCodeInUI) {
  //         availableTTSModelsForSelectedLangInUI.add(eachAvailableTTSModelData.modelId);
  //       }
  //     }
  //   }

  //   //Either select default model (vakyansh for now) or any random model from the available list.
  //   String ttsModelIDToUse = isAtLeastOneDefaultModelTypeFound
  //       ? availableTTSModelsForSelectedLangInUIDefault[Random().nextInt(availableTTSModelsForSelectedLangInUIDefault.length)]
  //       : availableTTSModelsForSelectedLangInUI[Random().nextInt(availableTTSModelsForSelectedLangInUI.length)];

  //   //Below two lines so that any changes are made to a new map, not the original format
  //   var ttsPayloadToSendForMale = {};
  //   ttsPayloadToSendForMale.addAll(AppConstants.TTS_PAYLOAD_FORMAT);

  //   // print('TTS Model ID used: https://bhashini.gov.in/ulca/search-model/$ttsModelIDToUse');

  //   ttsPayloadToSendForMale['modelId'] = ttsModelIDToUse;
  //   ttsPayloadToSendForMale['task'] = AppConstants.TYPES_OF_MODELS_LIST[2];
  //   ttsPayloadToSendForMale['input'][0]['source'] = transOutputAsTTSInputString;
  //   ttsPayloadToSendForMale['gender'] = 'male';

  //   var ttsPayloadToSendForFemale = {};
  //   ttsPayloadToSendForFemale.addAll(ttsPayloadToSendForMale);
  //   ttsPayloadToSendForFemale['gender'] = 'female';

  //   List<Map<String, dynamic>> responseList =
  //       await _translationAppAPIClient.sendTTSReqForBothGender(ttsPayloadList: [ttsPayloadToSendForMale, ttsPayloadToSendForFemale]);

  //   if (responseList.isEmpty) {
  //     return [];
  //   }

  //   return [responseList[0]['output']['audio'][0]['audioContent'] ?? '', responseList[1]['output']['audio'][0]['audioContent'] ?? ''];
  // }
}
