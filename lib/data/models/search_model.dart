class SearchModel {
  late String message;
  late List<Data> data;
  late int count;

  SearchModel({
    required this.message,
    required this.data,
    required this.count,
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['count'] = count;
    return data;
  }
}

class Data {
  late List<Languages> languages;
  late String modelId;
  late String userId;
  late String name;

  Data({
    required this.languages,
    required this.modelId,
    required this.userId,
    required this.name,
  });

  Data.fromJson(Map<String, dynamic> json) {
    modelId = json['modelId'];
    userId = json['userId'];
    name = json['name'];

    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages.add(Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['languages'] = languages.map((v) => v.toJson()).toList();
    data['modelId'] = modelId;
    data['userId'] = userId;
    data['name'] = name;
    return data;
  }
}

class Languages {
  String? sourceLanguageName;
  String? sourceLanguage;
  String? targetLanguageName;
  String? targetLanguage;

  Languages({this.sourceLanguageName, this.sourceLanguage, this.targetLanguageName, this.targetLanguage});

  Languages.fromJson(Map<String, dynamic> json) {
    sourceLanguageName = json['sourceLanguageName'] ?? 'No Source Language Name detected';
    sourceLanguage = json['sourceLanguage'] ?? 'No Source Language Code detected';
    targetLanguageName = json['targetLanguageName'] ?? 'No Target Language Name detected';
    targetLanguage = json['targetLanguage'] ?? 'No Target Language Code detected';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sourceLanguageName'] = sourceLanguageName;
    data['sourceLanguage'] = sourceLanguage;
    data['targetLanguageName'] = targetLanguageName;
    data['targetLanguage'] = targetLanguage;
    return data;
  }
}
