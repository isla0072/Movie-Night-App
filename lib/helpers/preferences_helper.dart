import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class PreferencesHelper {
  static const _deviceIdKey = 'device_id';
  static const _sessionIdKey = 'session_id';

  static Future<bool> saveDeviceId(String deviceId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_deviceIdKey, deviceId);
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when saving the device Id: $e');
      }
      return false;
    }
  }

  static Future<String?> getDeviceId() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_deviceIdKey);
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when getting the device Id: $e');
      }
      return null;
    }
  }

  static Future<bool> saveSessionId(String sessionId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_sessionIdKey, sessionId);
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when saving the session Id: $e');
      }
      return false;
    }
  }

  static Future<String?> getSessionId() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(_sessionIdKey);
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when saving the session Id: $e');
      }
      return null;
    }
  }

  static Future<bool> clearPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.clear();
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when clearing the: $e');
      }
      return false;
    }
  }
}
