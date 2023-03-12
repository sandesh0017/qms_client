import 'dart:convert';
import 'package:qms_client/core/constants/api_endpoints.dart';
import 'package:qms_client/models/user_session_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionPreferences {
  static Future<SharedPreferences> _initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  Future<void> setSession({required UserSession userSession}) async {
    SharedPreferences prefs = await _initSharedPreferences();
    prefs.setString('session', jsonEncode(userSession));
  }

  Future<bool> clearSession() async {
    SharedPreferences prefs = await _initSharedPreferences();
    return prefs.remove('session');
  }

  Future<UserSession?> getSession() async {
    SharedPreferences prefs = await _initSharedPreferences();
    String? sessionString = prefs.getString('session');
    if (sessionString != null) {
      UserSession session = UserSession.fromJson(jsonDecode(sessionString));
      return session;
    } else {
      return null;
    }
  }

  Future<void> setBaseUrl({required String baseUrl}) async {
    SharedPreferences prefs = await _initSharedPreferences();
    prefs.setString('baseUrl', baseUrl);
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await _initSharedPreferences();
    String? baseUrl = prefs.getString('baseUrl');
    if (baseUrl != null) {
      return baseUrl;
      // UserSession session = UserSession.fromJson(jsonDecode(sessionString));
      // return session;
    } else {
      return ApiUrl.baseUrl;
    }
  }
}
