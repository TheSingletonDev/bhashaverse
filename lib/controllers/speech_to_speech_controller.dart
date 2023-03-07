import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';

import '../config/app_constants.dart';
import '../data/translation_app_api_client.dart';
import 'app_ui_controller.dart';
import 'hardware_requests_controller.dart';
import 'language_model_controller.dart';

class SpeechToSpeechController extends GetxController {
  late AppUIController _appUIController;
  late HardwareRequestsController _hardwareRequestsController;
  late TranslationAppAPIClient _translationAppAPIClient;
  late LanguageModelController _languageModelController;

  // String asrResponseText = '';
  // String transResponseText = '';

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
    _languageModelController = Get.find();
  }

  /*Or can do 2 separate functions. One with async-await and await all methods instead of .then() and then call
  this new method in non-future type method with .then() appearing once!*/

  void sendSpeechToSpeechRequests({required String base64AudioContent}) {
    _sendSpeechToSpeechRequestsInternal(base64AudioContent: base64AudioContent).then((_) {});
  }

  Future _sendSpeechToSpeechRequestsInternal({required String base64AudioContent}) async {
    try {
      Stopwatch watch = Stopwatch();

      watch.start();
      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: true);

      _appUIController.changeCurrentRequestStatusForUI(
          newStatus: AppConstants.SPEECH_RECG_REQ_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));

      var stsOutput = await _getSTSOutput(base64AudioContent: base64AudioContent);

      String ttsMaleOutputBase64String = '';
      String ttsFemaleOutputBase64String = '';

      for (var eachTaskResponse in stsOutput['pipelineResponse']) {
        if (eachTaskResponse['taskType'] == 'asr') {
          _asrResponseText = eachTaskResponse['output'][0]['source'];
        }
        if (eachTaskResponse['taskType'] == 'translation') {
          _transResponseText = eachTaskResponse['output'][0]['target'];
        }
        if (eachTaskResponse['taskType'] == 'tts') {
          ttsMaleOutputBase64String = eachTaskResponse['audio'][0]['audioContent'];
          ttsFemaleOutputBase64String = eachTaskResponse['audio'][0]['audioContent'];
        }
      }

      _appUIController.changeIsASRResponseGenerated(isASRResponseGenerated: true);
      _appUIController.changeIsTransResponseGenerated(isTransResponseGenerated: true);

      await _hardwareRequestsController.requestPermissions();
      String appDocPath = await _hardwareRequestsController.getAppDirPath();

      if (ttsMaleOutputBase64String.isNotEmpty) {
        var maleFileAsBytes = base64Decode(ttsMaleOutputBase64String);
        String maleTTSAudioFileName = '$appDocPath/TTSMaleAudio.wav';
        final maleAudioFile = File(maleTTSAudioFileName);
        await maleAudioFile.writeAsBytes(maleFileAsBytes);
        _ttsMaleAudioFilePath = maleTTSAudioFileName;
        _appUIController.changeIsMaleTTSAvailable(isMaleTTSAvailable: true);
      }

      if (ttsFemaleOutputBase64String.isNotEmpty) {
        var femaleFileAsBytes = base64Decode(ttsFemaleOutputBase64String);
        String femaleTTSAudioFileName = '$appDocPath/TTSFemaleAudio.wav';
        final femaleAudioFile = File(femaleTTSAudioFileName);
        await femaleAudioFile.writeAsBytes(femaleFileAsBytes);
        _ttsFemaleAudioFilePath = femaleTTSAudioFileName;
        _appUIController.changeIsFemaleTTSAvailable(isFemaleTTSAvailable: true);
      }

      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
      _appUIController.changeHasSpeechToSpeechUpdateRequestsInitiated(hasSpeechToSpeechUpdateRequestsInitiated: false); // Only for Update Button

      _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: false);

      if (_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
        _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      } else if (_appUIController.isMaleTTSAvailable && !_appUIController.isFemaleTTSAvailable) {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
        _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.male);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      } else if (!_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
        _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      } else {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_FAIL_STATUS_MSG.tr.replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      }
      _appUIController.changeCurrentRequestStatusForUI(
          newStatus:
              'S2S for ${_appUIController.selectedSourceLangNameInUI}-${_appUIController.selectedTargetLangNameInUI} completed in ${(watch.elapsedMilliseconds / 1000).toPrecision(2)} seconds!');
    } on Exception {
      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
      _appUIController.changeHasSpeechToSpeechUpdateRequestsInitiated(hasSpeechToSpeechUpdateRequestsInitiated: false); //Only for Update Button
      _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: false);
      _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
    }
  }

  Future<dynamic> _getSTSOutput({required String base64AudioContent}) async {
    var stsPayloadToSend = {};
    stsPayloadToSend.addAll(AppConstants.STS_PAYLOAD_FORMAT);
    stsPayloadToSend['pipelineTasks'][0]['config']['language']['sourceLanguage'] = AppConstants.getLanguageCodeOrName(
      value: _appUIController.selectedSourceLangNameInUI,
      returnWhat: LANGUAGE_MAP.languageCode,
      lang_code_map: AppConstants.LANGUAGE_CODE_MAP,
    );
    stsPayloadToSend['pipelineTasks'][1]['config']['language']['sourceLanguage'] = AppConstants.getLanguageCodeOrName(
      value: _appUIController.selectedSourceLangNameInUI,
      returnWhat: LANGUAGE_MAP.languageCode,
      lang_code_map: AppConstants.LANGUAGE_CODE_MAP,
    );
    stsPayloadToSend['pipelineTasks'][1]['config']['language']['targetLanguage'] = AppConstants.getLanguageCodeOrName(
      value: _appUIController.selectedTargetLangNameInUI,
      returnWhat: LANGUAGE_MAP.languageCode,
      lang_code_map: AppConstants.LANGUAGE_CODE_MAP,
    );
    stsPayloadToSend['pipelineTasks'][2]['config']['language']['sourceLanguage'] = AppConstants.getLanguageCodeOrName(
      value: _appUIController.selectedTargetLangNameInUI,
      returnWhat: LANGUAGE_MAP.languageCode,
      lang_code_map: AppConstants.LANGUAGE_CODE_MAP,
    );
    stsPayloadToSend['inputData']['audio'][0]['audioContent'] = base64AudioContent;

    var computeURL = _languageModelController.ulcaPipelineConfig['pipelineInferenceAPIEndPoint']['callbackUrl'];
    var computeAPIKeyName = _languageModelController.ulcaPipelineConfig['pipelineInferenceAPIEndPoint']['inferenceApiKey']['name'];
    var computeAPIKeyValue = _languageModelController.ulcaPipelineConfig['pipelineInferenceAPIEndPoint']['inferenceApiKey']['value'];

    var response = await _translationAppAPIClient.sendPipelineComputeRequest(
      computeURL: computeURL,
      computeAPIKeyName: computeAPIKeyName,
      computeAPIKeyValue: computeAPIKeyValue,
      computePayload: stsPayloadToSend,
    );
    return response;
  }
}
