import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrences {
  static void storeUserData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'username': username,
    });
    prefs.setString('userData', userData);
  }
}
