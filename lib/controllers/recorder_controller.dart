import 'dart:convert';
import 'dart:io';

import 'package:bhashaverse/controllers/speech_to_speech_controller.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';

import '../config/app_constants.dart';
import 'app_ui_controller.dart';
import 'hardware_requests_controller.dart';

class RecorderController extends GetxController {
  late FlutterSoundRecorder _audioRec;
  late FlutterSoundPlayer _audioPlayer;
  late String _recordedAudioFileName;
  // late String _audioToBase64FileName;
  late AppUIController _appUIController;
  late HardwareRequestsController _hardwareRequestsController;
  late SpeechToSpeechController _speechToSpeechController;

  String _base64EncodedAudioContent = '';

  @override
  void onInit() {
    super.onInit();
    _recordedAudioFileName = 'ASRAudio.wav';
    _audioRec = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
  }

  Future record() async {
    try {
      _hardwareRequestsController = Get.find();
      _speechToSpeechController = Get.find();
      _appUIController = Get.find();

      _appUIController.changeIsASRResponseGenerated(isASRResponseGenerated: false);
      _appUIController.changeIsTransResponseGenerated(isTransResponseGenerated: false);
      _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);

      await _hardwareRequestsController.requestPermissions();
      if (_hardwareRequestsController.arePermissionsGranted) {
        _appUIController.changeCurrentRequestStatusForUI(newStatus: AppConstants.USER_VOICE_RECORDING_STATUS_MSG.tr);
        await _audioRec.openRecorder();
        String appDocPath = await _hardwareRequestsController.getAppDirPath();
        _appUIController.changeIsUserRecording(isUserRecording: true);
        await _audioRec.startRecorder(toFile: '$appDocPath/$_recordedAudioFileName');
      } else {
        _appUIController.changeIsUserRecording(isUserRecording: false);
      }
    } catch (e) {
      _appUIController.changeIsUserRecording(isUserRecording: false);
    }
  }

  Future stop() async {
    try {
      await _audioRec.stopRecorder();
      String appDocPath = await _hardwareRequestsController.getAppDirPath();
      File audioWavInputFile = File('$appDocPath/$_recordedAudioFileName');
      final bytes = audioWavInputFile.readAsBytesSync();
      _base64EncodedAudioContent = base64Encode(bytes);

      await audioWavInputFile.delete();
      _disposeRecorder();

      _speechToSpeechController.sendSpeechToSpeechRequests(base64AudioContent: _base64EncodedAudioContent);
    } catch (e) {
      _appUIController.changeIsUserRecording(isUserRecording: false);
    }
  }

  Future playback() async {
    await _audioPlayer.openPlayer();
    _appUIController.changeIsTTSOutputPlaying(isTTSOutputPlaying: true);

    await _audioPlayer.startPlayer(
        fromURI: _appUIController.selectedGenderInUI == GENDER.female
            ? _speechToSpeechController.ttsFemaleAudioFilePath
            : _speechToSpeechController.ttsMaleAudioFilePath,
        whenFinished: () {
          stopPlayback();
        });
  }

  Future stopPlayback() async {
    await _audioPlayer.stopPlayer();
    _disposePlayer();
  }

  void _disposeRecorder() {
    _audioRec.isRecording ? _audioRec.closeRecorder() : null;
    _appUIController.changeIsUserRecording(isUserRecording: false);
  }

  void _disposePlayer() {
    !_audioPlayer.isPlaying ? _audioPlayer.closePlayer() : null;
    _appUIController.changeIsTTSOutputPlaying(isTTSOutputPlaying: false);
  }
}
