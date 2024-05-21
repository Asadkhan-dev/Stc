import 'dart:async';
import "dart:convert";
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/GetStoreTableModel.dart';
import '../models/inputToStoreTableModel.dart';
import '../requestJson/getstoretableconverter.dart';
import '../url/api.dart';

class StoreTablesProvider with ChangeNotifier {
  List<GetStoreTableModel> _storeTables = [];
  String? storeName;

  List<GetStoreTableModel> get getstoreTableItems {
    return [..._storeTables];
  }

  String? get getStorename {
    return storeName;
  }

  void setStoreName(String storename) {
    storeName = storename;
  }

  Future<bool> fetchTables(String username, String workingid, String storeid,
      String companyid, String clientvisitType) async {
    final url = Uri.parse(Api.getStoreTables);

    try {
      final jsondata = InputToStoreTableModel(
              username: username,
              workingId: workingid,
              storeId: storeid,
              companyId: companyid,
              clientVisitType: clientvisitType)
          .toJson();

      final response = await http
          .post(url, body: jsondata)
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        if (responseData["isAction"]) {
          final extractedData = responseData["data"];

          List<GetStoreTableModel> loadedItems = [];

          extractedData.forEach((item) {
            loadedItems.insert(0, GetStoreTableModel.fromJson(item));
          });
          _storeTables = loadedItems.reversed.toList();

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

  Future<bool> uploadTableImage(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String photoTypeId,
      String photoImage,
      String tableNameId,
      String clientVisitType) async {
    final url = Uri.parse(Api.uploadPhotoActivity);
    try {
      final response = await http
          .post(url,
              body: GetStoreTableConverter.uploadImageToJson(
                  username,
                  workingId,
                  storeId,
                  companyId,
                  tableTypeId,
                  photoTypeId,
                  photoImage,
                  tableNameId,
                  clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

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
