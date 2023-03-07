import 'dart:convert';

import 'package:dio/dio.dart';
import '../config/app_constants.dart';
import 'models/search_model.dart';

class TranslationAppAPIClient {
  late Dio _dio;

  static TranslationAppAPIClient? translationAppAPIClient;

  TranslationAppAPIClient(dio) {
    _dio = dio;
  }

  static TranslationAppAPIClient getAPIClientInstance() {
    var options = BaseOptions(
      baseUrl: AppConstants.STS_BASE_URL,
      connectTimeout: 80000,
      receiveTimeout: 50000,
      validateStatus: (status) => true, // Without this, if status code comes other than 200, DIO throws Exception
    );

    translationAppAPIClient = translationAppAPIClient ?? TranslationAppAPIClient(Dio(options));
    return translationAppAPIClient!;
  }

  Future<List<Map<String, dynamic>>> getAllModels({required List<dynamic> taskPayloads}) async {
    try {
      final asrTranslationTtsResponses =
          await Future.wait(taskPayloads.map((eachTaskPayload) => _dio.post(AppConstants.SEARCH_REQ_URL, data: eachTaskPayload)));

      asrTranslationTtsResponses.asMap().entries.map((eachResponse) {
        if (eachResponse.value.statusCode != 200) {
          return [];
        }
      }).toList();

      List<Map<String, dynamic>> asrTranslationTTSResponsesList = [];

      /*
      Could have done asrTranslationTtsResponses.map((e){}) but to access the index of each element,
      use .asMap().entries.map((e){}). Index: e.key, Original Value: e.value
      */
      asrTranslationTtsResponses.asMap().entries.map((eachResponse) {
        asrTranslationTTSResponsesList
            .add({'taskType': taskPayloads[eachResponse.key]['task'], 'modelInstance': SearchModel.fromJson(eachResponse.value.data)});
      }).toList();

      return asrTranslationTTSResponsesList;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> sendULCAConfigRequest({required configPayload}) async {
    try {
      var response = await _dio.post(AppConstants.CONFIG_REQ_URL,
          data: configPayload,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'ulcaApiKey': const String.fromEnvironment('ULCA_API_KEY'),
            'userID': const String.fromEnvironment('ULCA_USER_ID'),
          }));
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> sendPipelineComputeRequest(
      {required computeURL, required computeAPIKeyName, required computeAPIKeyValue, required computePayload}) async {
    try {
      Dio dio = Dio(BaseOptions(connectTimeout: 80000, receiveTimeout: 50000, validateStatus: (status) => true));
      var response = await dio.post(computeURL,
          data: computePayload,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*',
            computeAPIKeyName: computeAPIKeyValue,
          }));
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> sendASRRequest({required asrPayload}) async {
    try {
      var response = await _dio.post(AppConstants.ASR_REQ_URL,
          data: asrPayload, options: Options(headers: {'Content-Type': 'application/json', 'Accept': '*/*'}));
      if (response.statusCode == 200) {
        if (response.data['message'] == 'Request successful') {
          return response.data['data'];
        }
        return {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> sendTranslationRequest({required transPayload}) async {
    try {
      var response = await _dio.post(AppConstants.TRANS_REQ_URL,
          data: transPayload, options: Options(headers: {'Content-Type': 'application/json', 'Accept': '*/*'}));
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> sendTTSRequest({required ttsPayload}) async {
    try {
      var response = await _dio.post(AppConstants.TTS_REQ_URL,
          data: ttsPayload, options: Options(headers: {'Content-Type': 'application/json', 'Accept': '*/*'}));
      if (response.statusCode == 200) {
        return response.data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<dynamic> sendTTSReqForBothGender({required List<dynamic> ttsPayloadList}) async {
    try {
      final ttsResponsesList = await Future.wait(ttsPayloadList.map((eachTaskPayload) => _dio.post(AppConstants.TTS_REQ_URL,
          data: eachTaskPayload, options: Options(headers: {'Content-Type': 'application/json', 'Accept': '*/*'}))));

      List<Map<String, dynamic>> ttsOutputResponsesList = [];

      /*
      Could have done asrTranslationTtsResponses.map((e){}) but to access the index of each element,
      use .asMap().entries.map((e){}). Index: e.key, Original Value: e.value
      */
      ttsResponsesList.asMap().entries.map((eachResponse) {
        if (eachResponse.value.statusCode == 200) {
          ttsOutputResponsesList.add({'gender': ttsPayloadList[eachResponse.key]['gender'], 'output': eachResponse.value.data});
        } else {
          ttsOutputResponsesList.add({'gender': ttsPayloadList[eachResponse.key]['gender'], 'output': eachResponse.value.data});
        }
      }).toList();

      return ttsOutputResponsesList;
    } on Exception {
      return [];
    }
  }
}
