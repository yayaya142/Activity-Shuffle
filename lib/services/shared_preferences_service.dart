library my_app.globals;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

ValueNotifier<bool> audioWorkoutActive = ValueNotifier<bool>(false);

class SharedPreferencesService {
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();
  SharedPreferences? _preferences;

  // Singleton pattern: access instance globally
  factory SharedPreferencesService() {
    return _instance;
  }

  SharedPreferencesService._internal();

  // Initialize the SharedPreferences instance
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save a string list (for exercises or any other list)
  Future<void> saveStringList(String key, List<String> values) async {
    await _preferences?.setStringList(key, values);
  }

  // Get a string list
  List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  // Save a single string value
  Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get a single string value
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get a boolean value
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Save an integer value
  Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Get an integer value
  int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Clear specific key
  Future<void> clearKey(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all preferences
  Future<void> clearAll() async {
    await _preferences?.clear();
  }
}
