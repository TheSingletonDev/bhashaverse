import 'package:get/get.dart';

import '../config/app_constants.dart';

class AppUIController extends GetxController {
  bool _areModelsLoadedSuccessfully = false;
  bool get areModelsLoadedSuccessfully => _areModelsLoadedSuccessfully;
  void changeAreModelsLoadedSuccessfully({required bool areModelsLoadedSuccessfully}) {
    _areModelsLoadedSuccessfully = areModelsLoadedSuccessfully;
    update();
  }

  String _selectedSourceLanguageInUI = '';
  String get selectedSourceLangNameInUI => _selectedSourceLanguageInUI;
  void changeSourceLanguage({required String selectedSourceLanguageInUI}) {
    _selectedSourceLanguageInUI = selectedSourceLanguageInUI;
    update();
  }

  String _selectedTargetLanguageInUI = '';
  String get selectedTargetLangNameInUI => _selectedTargetLanguageInUI;
  void changeTargetLanguage({required String selectedTargetLanguageName}) {
    changeIsASRResponseGenerated(isASRResponseGenerated: false);
    changeIsTransResponseGenerated(isTransResponseGenerated: false);
    changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);

    changeIsMaleTTSAvailable(isMaleTTSAvailable: false);
    changeIsFemaleTTSAvailable(isFemaleTTSAvailable: false);

    changeCurrentRequestStatusForUI(newStatus: AppConstants.INITIAL_CURRENT_STATUS_VALUE.tr);
    _selectedTargetLanguageInUI = selectedTargetLanguageName;
    update();
  }

  var _selectedGenderInUI = GENDER.female;
  GENDER get selectedGenderInUI => _selectedGenderInUI;
  void changeSelectedGenderForTTSInUI({required GENDER selectedGenderForTTS}) {
    _selectedGenderInUI = selectedGenderForTTS;
    update();
  }

  bool _isASRResponseGenerated = false;
  bool get isASRResponseGenerated => _isASRResponseGenerated;
  void changeIsASRResponseGenerated({required bool isASRResponseGenerated}) {
    _isASRResponseGenerated = isASRResponseGenerated;
    update();
  }

  bool _isTransResponseGenerated = false;
  bool get isTransResponseGenerated => _isTransResponseGenerated;
  void changeIsTransResponseGenerated({required bool isTransResponseGenerated}) {
    _isTransResponseGenerated = isTransResponseGenerated;
    update();
  }

  /* ASR and Translation Request Initiation is not needed coz
  for TTS we are showing loading symbol instead of Play Button*/
  bool _hasTTSRequestInitiated = false;
  bool get hasTTSRequestInitiated => _hasTTSRequestInitiated;
  void changeHasTTSRequestInitiated({required bool hasTTSRequestInitiated}) {
    _hasTTSRequestInitiated = hasTTSRequestInitiated;
    update();
  }

  bool _isTTSResponseFileGenerated = false;
  bool get isTTSResponseFileGenerated => _isTTSResponseFileGenerated;
  void changeIsTTSResponseFileGenerated({required bool isTTSResponseFileGenerated}) {
    _isTTSResponseFileGenerated = isTTSResponseFileGenerated;
    update();
  }

  String _currentRequestStatusForUI = '';
  String get currentRequestStatusForUI => _currentRequestStatusForUI;
  void changeCurrentRequestStatusForUI({required String newStatus}) {
    _currentRequestStatusForUI = newStatus;
    update();
  }

  bool _hasSpeechToSpeechRequestsInitiated = false;
  bool get hasSpeechToSpeechRequestsInitiated => _hasSpeechToSpeechRequestsInitiated;
  void changeHasSpeechToSpeechRequestsInitiated({required bool hasSpeechToSpeechRequestsInitiated}) {
    _hasSpeechToSpeechRequestsInitiated = hasSpeechToSpeechRequestsInitiated;
    update();
  }

  bool _areTargetLangForSelectedSourceLangLoaded = false;
  bool get areTargetLangForSelectedSourceLangLoaded => _areTargetLangForSelectedSourceLangLoaded;
  void chnageAreTargetLangForSelectedSourceLangLoaded({required bool areTargetLangForSelectedSourceLangLoaded}) {
    _areTargetLangForSelectedSourceLangLoaded = areTargetLangForSelectedSourceLangLoaded;
    update();
  }

  bool _isUserRecording = false;
  bool get isUserRecording => _isUserRecording;
  void changeIsUserRecording({required bool isUserRecording}) {
    _isUserRecording = isUserRecording;
    update();
  }

  bool _isFemaleTTSAvailable = false;
  bool get isFemaleTTSAvailable => _isFemaleTTSAvailable;
  void changeIsFemaleTTSAvailable({required bool isFemaleTTSAvailable}) {
    _isFemaleTTSAvailable = isFemaleTTSAvailable;
    update();
  }

  bool _isMaleTTSAvailable = false;
  bool get isMaleTTSAvailable => _isMaleTTSAvailable;
  void changeIsMaleTTSAvailable({required bool isMaleTTSAvailable}) {
    _isMaleTTSAvailable = isMaleTTSAvailable;
    update();
  }

  bool _isTTSOutputPlaying = false;
  bool get isTTSOutputPlaying => _isTTSOutputPlaying;
  void changeIsTTSOutputPlaying({required bool isTTSOutputPlaying}) {
    _isTTSOutputPlaying = isTTSOutputPlaying;
    update();
  }
}
