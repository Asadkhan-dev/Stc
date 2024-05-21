import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cstore/requestJson/tableSlotConverter.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

import '../models/getTableSlotModel.dart';
import '../models/imageReason.dart';
import '../models/reason.dart';
import '../models/securityToolModel.dart';
import '../models/skumodel.dart';
import '../url/api.dart';

class TableSlotProvider with ChangeNotifier {
  List updatedSlotList = [];

  List<ImageReasonModel> imgReason = [];

  List<GetTableSlotModel> slotsData = [];

  List<SecurityToolModel> securityToolData = [];
  List<ReasonModel> reasonData = [];
  List<SkuModel> skuData = [];

  List<ImageReasonModel>? get getImageReason {
    return [...imgReason];
  }

  List<GetTableSlotModel>? get getTableSlots {
    return [...slotsData];
  }

  List<SecurityToolModel> get getSecurityToolItem {
    return [...securityToolData];
  }

  List<ReasonModel> get getReasonItem {
    return [...reasonData];
  }

  List<SkuModel> get getSKUItem {
    return [...skuData];
  }

  SecurityToolModel findSecurityElement(int id) {
    return securityToolData
        .firstWhere((element) => element.securityToolId == id);
  }

  SkuModel findSKUElement(int id) {
    return skuData.firstWhere((element) => element.skuId == id);
  }

  ReasonModel findReason(int id) {
    return reasonData.firstWhere((element) => element.reason == id);
  }

  Map<String, dynamic> createString(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) {
    Map<String, dynamic> mymap = {
      "username": userName,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "table_type_id": tableTypeId,
      "table_name_id": tableNameId,
      "client_visit_type": clientVisitType
    };
    return mymap;
  }

  Future<void> fetchTableSlot(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) async {
    final url = Uri.parse(Api.getTableSlot);
    try {
      final response = await http
          .post(url,
              body: createString(userName, workingId, storeId, companyId,
                  tableTypeId, tableNameId, clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        final extractedData = responseData["data"];

        if (responseData["isAction"]) {
          List<GetTableSlotModel> _loadedItems = [];
          updatedSlotList = [];

          extractedData.forEach((item) {
            _loadedItems.insert(0, GetTableSlotModel.fromJson(item));
            updatedSlotList.insert(0, item);
          });
          slotsData = _loadedItems.reversed.toList();
          updatedSlotList = updatedSlotList.reversed.toList();

          notifyListeners();
        }
      }
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchphotoTypes(
      String user,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) async {
    final url = Uri.parse(Api.getPhotoTypesByTable);
    try {
      final response = await http.post(url, body: {
        "username": user,
        "working_id": workingId,
        "store_id": storeId,
        "company_id": companyId,
        "table_type_id": tableTypeId,
        "table_name_id": tableNameId,
        "client_visit_type": clientVisitType
      }).timeout(const Duration(seconds: 45));
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        final extractedData = responseData["data"];

        List<ImageReasonModel> loadedData = [];
        if (responseData["isAction"]) {
          extractedData.forEach((item) {
            loadedData.insert(0, ImageReasonModel.fromJson(item));
          });
          imgReason = loadedData;
          notifyListeners();
        }
      }
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchSkus(String username, String workingId, String storeId,
      String companyId, String tableTypeId, String clientVisitType) async {
    final url = Uri.parse(Api.getSkUs);
    try {
      final response = await http
          .post(url,
              body: TableSlotConverter.skuJson(username, workingId, storeId,
                  companyId, tableTypeId, clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        if (responseData["isAction"]) {
          final extractedData = responseData["data"];
          List<SkuModel> loadedItems = [
            SkuModel(skuId: 0, skuName: "Select Item")
          ];
          extractedData.forEach((item) {
            loadedItems.insert(0, SkuModel.fromJson(item));
          });
          skuData = loadedItems;
          notifyListeners();
        }
      }
    } on TimeoutException {
      throw ("Slow internet connection");
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> fetchMasterList(String userName, String workingId,
      String tableTypeId, String clientVisitType) async {
    final url = Uri.parse(Api.masterListElement);

    try {
      final response = await http
          .post(url,
              body: TableSlotConverter.createMasterString(
                  userName, workingId, tableTypeId, clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        final photoTypeExtracted = responseData["data"]["photoTypeList"];
        final securityToolsExtracted =
            responseData["data"]["securityToolsList"];
        final notWorkingReasonExtracted =
            responseData["data"]["notWorkingReasonList"];

        if (responseData["isAction"]) {
          // List<ImageReasonModel> loadedData = [];

          // photoTypeExtracted.forEach((element) {
          //   loadedData.insert(0, ImageReasonModel.fromJson(element));
          // });
          // imgReason = loadedData;

          List<SecurityToolModel> loadedData1 = [
            SecurityToolModel(securityToolId: 0, name: "Security Tool")
          ];
          securityToolsExtracted.forEach((element) {
            loadedData1.insert(0, SecurityToolModel.fromJson(element));
          });
          securityToolData = loadedData1;

          List<ReasonModel> loadedData2 = [
            ReasonModel(reason: 0, reasonName: "Reason")
          ];
          notWorkingReasonExtracted.forEach((element) {
            loadedData2.insert(0, ReasonModel.fromJson(element));
          });
          reasonData = loadedData2;

          notifyListeners();
          return responseData["isAction"];
        }
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

  Future<bool> updateAllSlot() async {
    final url = Uri.parse(Api.updateAllSlot);

    try {
      final response = await http
          .post(url, body: json.encode({"data": updatedSlotList}))
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
      throw error;
    }
  }

  void updateSlotsArray(
      int slotNum,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String tableType,
      String tableName,
      int slotUtilizingId,
      String statusData,
      String notWorking,
      int reasonData,
      int securityToolId,
      int skuId,
      double price) {
    if (statusData == "0") {
      reasonData = 0;
      securityToolId = 0;
      notWorking = "0";
      skuId = 0;
      price = 0.0;
    }
    if (notWorking == "Working") {
      notWorking = "0";
      reasonData = 0;
    } else if (notWorking == "NotWorking") {
      notWorking = "1";
    }

    Map<String, dynamic> myMap = {
      "company_id": int.parse(companyId),
      "working_id": int.parse(workingId),
      "slot_utilizing_id": slotUtilizingId,
      "store_id": int.parse(storeId),
      "table_type_id": int.parse(tableTypeId),
      "table_name_id": int.parse(tableNameId),
      "table_type": tableType,
      "table_name": tableName,
      "slot_no": slotNum,
      "status": int.parse(statusData),
      "not_working_check": int.parse(notWorking),
      "reason": reasonData,
      "security_tool_id": securityToolId,
      "sku_id": skuId,
      "price": price,
      "activity_status": 0
    };

    updatedSlotList.removeAt(slotNum - 1);
    updatedSlotList.insert(slotNum - 1, myMap);
  }
}
