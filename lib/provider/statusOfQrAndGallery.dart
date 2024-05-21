import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cstore/models/statusofQrAndGallery.dart';
import 'package:cstore/url/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class StatusOfQrAndGalleryProvider with ChangeNotifier {
  StatusOfQrandGalleryModel? _QrAndGalleryDataModel;

  StatusOfQrandGalleryModel? get QrAndGalleryData {
    return _QrAndGalleryDataModel;
  }

  Map<String, dynamic> createQrAndGalleryMap(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": userName,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "table_type_id": tableTypeId,
      "table_name_id": tableNameId,
      "client_visit_type": clientVisitType
    };
    return myMap;
  }

  Future<void> fetchTableImageQrStatus(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) async {
    try {
      final url = Uri.parse(Api.statusOfQrCodeAndGallery);
      final response = await http
          .post(url,
              body: createQrAndGalleryMap(userName, workingId, storeId,
                  companyId, tableTypeId, tableNameId, clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        _QrAndGalleryDataModel = StatusOfQrandGalleryModel(
            pictureCount: responseData["pictureCount"],
            qrActivityStatus: responseData["qrData"][0]["qr_activity_status"],
            qrStatus: responseData["qrData"][0]["qr_status"]);
        notifyListeners();
      }
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      throw error;
    }
  }

  void decrementImageCount() {
    _QrAndGalleryDataModel!.pictureCount =
        _QrAndGalleryDataModel!.pictureCount - 1;
    notifyListeners();
  }

  void incrementImageCount() {
    _QrAndGalleryDataModel!.pictureCount =
        _QrAndGalleryDataModel!.pictureCount + 1;
    notifyListeners();
  }

  Map<String, dynamic> createQrSubmitMap(
      String user,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      int qrstatus,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": user,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "table_type_id": tableTypeId,
      "table_name_id": tableNameId,
      "qr_status": qrstatus.toString(),
      "client_visit_type": clientVisitType
    };
    return myMap;
  }

  Future<bool> postQrCodeData(
      String user,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      int qrstatus,
      String clientVisittype) async {
    try {
      final url = Uri.parse(Api.postQrData);

      final response = await http
          .post(url,
              body: createQrSubmitMap(user, workingId, storeId, companyId,
                  tableTypeId, tableNameId, qrstatus, clientVisittype))
          .timeout(const Duration(seconds: 45));
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData["isAction"]) {
          _QrAndGalleryDataModel!.qrActivityStatus = 1;
          _QrAndGalleryDataModel!.qrStatus = qrstatus;
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
