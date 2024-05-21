import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth.dart';
import '../models/user_model.dart';
import '../url/api.dart';

class AuthProivder with ChangeNotifier {
  UserModel? _userDataModel;
  bool auth = false;

  bool get isAuth {
    return auth;
  }

  UserModel? get userData {
    return _userDataModel;
  }

  Future<bool> login(String userName, String password) async {
    final url = Uri.parse(Api.loginApi);
    try {
      final response = await http
          .post(url,
              body: Auth(username: userName, password: password).toJson())
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        if (responseData["isAction"]) {
          _userDataModel = UserModel(
              username: responseData["data"][0]["username"].toString(),
              companyName: responseData["data"][0]["company_name"],
              welcomeMsg: responseData["data"][0]["welcome_msg"],
              tmrpic: responseData["data"][0]["tmr_pic"]);

          notifyListeners();

          await sharedPreferncesFtn(
              responseData["data"][0]["username"].toString(),
              responseData["data"][0]["welcome_msg"].toString(),
              responseData["data"][0]["company_name"],
              responseData["data"][0]["tmr_pic"]);
          auth = true;
        }
        return responseData["isAction"];
      }
      return false;
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sharedPreferncesFtn(String username, String welcomeMsg,
      String companyName, String tmrPic) async {
    final prefs = await SharedPreferences.getInstance();
    final userInformation = json.encode({
      "username": username,
      "welcome_msg": welcomeMsg,
      "companyname": companyName,
      "tmrpic": tmrPic
    });
    prefs.setString("userInfo", userInformation);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("userInfo")) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userInfo')!) as Map<String, dynamic>;
    final userName = extractedUserData['username'] as String;
    final welcomeMessg = extractedUserData["welcome_msg"] as String;
    final companyName = extractedUserData['companyname'] as String;
    final tmrpic = extractedUserData['tmrpic'] as String;

    // auth is used because I  should know that user is login
    auth = true;

    _userDataModel = UserModel(
        username: userName,
        welcomeMsg: welcomeMessg,
        companyName: companyName,
        tmrpic: tmrpic);
    notifyListeners();
    return true;
  }

  Future<void> logOut() async {
    auth = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
