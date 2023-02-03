import 'package:get/get.dart';

import 'controllers/app_ui_controller.dart';
import 'controllers/language_model_controller.dart';
import 'controllers/hardware_requests_controller.dart';
import 'controllers/recorder_controller.dart';
import 'controllers/speech_to_speech_controller.dart';
import 'data/translation_app_api_client.dart';

class TranslationAppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(TranslationAppAPIClient.getAPIClientInstance(), permanent: true);
    Get.put(AppUIController(), permanent: true);
    Get.put(LanguageModelController(), permanent: true);
    Get.put(RecorderController(), permanent: true);

    Get.lazyPut(() => HardwareRequestsController(), fenix: true);
    Get.lazyPut(() => SpeechToSpeechController(), fenix: true);
  }
}
