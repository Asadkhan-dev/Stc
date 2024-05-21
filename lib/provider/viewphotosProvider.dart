import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cstore/models/capturemodels.dart';
import 'package:cstore/requestJson/viewphotosConverter.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../url/api.dart';

class ViewPhotosProvider with ChangeNotifier {
  List<CapturePhotosModel> _capturephotos = [];

  List<CapturePhotosModel>? get getcaptureItem {
    return [..._capturephotos];
  }

  bool deleteImage(int i) {
    notifyListeners();
    return false;
  }

  Future<bool> deleteCaputreImage(
      int ind,
      String user,
      int workingId,
      int storeId,
      int companyId,
      int tableTypeId,
      int tableNameId,
      int imageId,
      String clientVisitType) async {
    final url = Uri.parse(Api.deleteImageApi);

    CapturePhotosModel captureImage = _capturephotos[ind];
    try {
      final response = await http
          .post(url,
              body: ViewPhotosConverter.submitDeleteMap(
                  user,
                  workingId,
                  storeId,
                  companyId,
                  tableTypeId,
                  tableNameId,
                  imageId,
                  clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        if (responseData["isAction"]) {
          _capturephotos.removeAt(ind);
          notifyListeners();
          return responseData["isAction"];
        }
        return responseData["isAction"];
      }
      return false;
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      throw error;
    }
  }

  Future<bool> fetchPhotos(
      String user,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) async {
    final url = Uri.parse(Api.getPhotos);

    try {
      final response = await http
          .post(url,
              body: ViewPhotosConverter.createfetchPhotosMap(
                  user,
                  workingId,
                  storeId,
                  companyId,
                  tableTypeId,
                  tableNameId,
                  clientVisitType))
          .timeout(Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);
        if (responseData["isAction"]) {
          final extractedData = responseData["data"];
          List<CapturePhotosModel> loadedItem = [];

          extractedData.forEach((item) {
            loadedItem.insert(0, CapturePhotosModel.fromJson(item));
          });
          _capturephotos = loadedItem;

          notifyListeners();
          return responseData["isAction"];
        }
        return false;
      }
      return false;
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      throw error;
    }
  }
}
