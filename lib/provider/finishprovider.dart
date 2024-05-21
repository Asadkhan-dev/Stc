import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cstore/requestJson/finishconverter.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../url/api.dart';

class FinishProvider with ChangeNotifier {
  Future<Map<String, dynamic>> finishVisit(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String imageText,
      String commentText,
      String lat,
      String long,
      String clientVisitType) async {
    final url = Uri.parse(Api.endVisit);

    try {
      final response = await http
          .post(url,
              body: Finishconverter.createFinishJson(
                  userName,
                  workingId,
                  storeId,
                  companyId,
                  imageText,
                  commentText,
                  lat,
                  long,
                  clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        return responseData;
      }

      return {
        "isAction": false,
        "msg": "Something went wrong please try later",
        "data": false
      };
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }
}
