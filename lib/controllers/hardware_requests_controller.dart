import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HardwareRequestsController extends GetxController {
  bool _arePermissionsGranted = false;
  bool get arePermissionsGranted => _arePermissionsGranted;

  Future requestPermissions() async {
    final micResStatus = await Permission.microphone.request();
    final storageResStatus = await Permission.storage.request();

    if (micResStatus == PermissionStatus.granted && storageResStatus == PermissionStatus.granted) {
      // throw RecordingPermissionException('Microphone and Storage permission not granted!');
      _arePermissionsGranted = true;
    }
  }

  Future<String> getAppDirPath() async {
    /* To write to external memory: /sdcard/Download/$_audioToBase64FileName*/

    Directory? appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir!.path;
    return appDocPath;
  }
}
