import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }


  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(value));
  }


  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static storeInt(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }


  static getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static storeBool(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }


  static getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }



}