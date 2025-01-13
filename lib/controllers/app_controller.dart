
import 'package:assentify_sdk/assentify_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class AppController {
  AppController._();

  static bool _gettingData = false;
  static bool get gettingData => _gettingData;
  static setgettingData(bool value) {
    _gettingData = value;
  }

  static bool _loading = false;
  static bool get loading => _loading;
  static setloading(bool value) {
    _loading = value;
  }

  static String _country = "";
  static String get country => _country;
  static setCountry(String newCountry) {
    _country = newCountry;
  }

  static ConfigModel? _configModel;
  static ConfigModel? get configModel => _configModel;
  static setConfigModel(ConfigModel configModel) {
    _configModel = configModel;
  }




  static Future<String> urlToBase64(String url, String apiKey) async {
    final headers = {
      "X-Api-Key": apiKey,
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final String base64Image = base64Encode(bytes);
      return base64Image;
    }
    return "";
  }
}
