import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/startvisitResponseModel.dart';
import '../models/startvisit_model.dart';
import '../url/api.dart';

class StartVisitProvider with ChangeNotifier {
  List<StartVisitResponseModel> _startvisitItems = [];

  List<StartVisitResponseModel> get getStartVisitItems {
    return [..._startvisitItems];
  }

  Future<bool> startVisit(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String lat,
      String long,
      String imagebase64,
      String clientVisitType) async {
    final url = Uri.parse(Api.startVisit);

    try {
      final response = await http
          .post(url,
              body: StartVisitModel.createjson(username, workingId, storeId,
                  companyId, lat + "," + long, imagebase64, clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        if (responseData["isAction"]) {
          List<StartVisitResponseModel> loadedItem = [];
          final extractedData = responseData["data"];
          extractedData.forEach((item) {
            print(item["working_id"].toString());
            print(item["store_id"].toString());
            print(item["company_id"].toString());
            loadedItem.insert(
                0,
                StartVisitResponseModel(
                    workingid: item["working_id"].toString(),
                    storeid: item["store_id"].toString(),
                    companyid: item["company_id"].toString(),
                    isAction: responseData["isAction"]));
          });
          _startvisitItems = loadedItem;
          notifyListeners();
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
}
