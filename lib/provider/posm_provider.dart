import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cstore/models/posmmodel.dart';
import 'package:cstore/models/posmphotomodel.dart';
import 'package:cstore/models/reasonpostmodel.dart';
import 'package:cstore/requestJson/posm_converter.dart';
import 'package:cstore/url/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PosmProvider with ChangeNotifier {
  Map<String, List<PosmModel>> posmDataMap = {};
  List<PosmPhotoModel> posmPhotoList = [];
  List<PosmReasonModel> posmReasons = [];

  List<dynamic> posmList = [];
  List<String> nameList = [];
  List<String> activityStatus = [];
  List<int> photoList = [];
  List<String> Status = [];
  List<String> comment = [];
  List<String> reportRecord = [];
  List<List<String>> labelList = [];
  List<List<String>> initialList = [];
  List<List<List<String>>> optionsList = [];
  List<TextEditingController> controller = [];

  Map<String, List<PosmModel>> getPosmDataMap() {
    return posmDataMap;
  }

  List<PosmReasonModel> get getPosmReason {
    return [...posmReasons];
  }

  List<PosmPhotoModel> get getPosmPhotoData {
    return [...posmPhotoList];
  }

  List<PosmModel> setTheModel(List<dynamic> mylst) {
    List<PosmModel> loadedElement = [];
    mylst.forEach((element) {
      loadedElement.insert(0, PosmModel.fromJson(element));
    });
    return loadedElement;
  }

  Future<void> fetchPosmProject(String userName, String workingId,
      String storeId, String companyId, String visitType) async {
    print("build");
    print(workingId);
    print(storeId);
    print(companyId);
    print(visitType);
    final url = Uri.parse(Api.getPosmProject);
    try {
      final response = await http
          .post(url,
              body: PosmConverter.postInputToJson(
                  userName, workingId, storeId, companyId, visitType))
          .timeout(const Duration(seconds: 45));
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData["isAction"]) {
          final extractedData = responseData["data"]["posms"];
          posmList.clear();
          nameList.clear();
          activityStatus.clear();
          Status.clear();
          comment.clear();
          reportRecord.clear();
          labelList.clear();
          initialList.clear();
          optionsList.clear();
          photoList.clear();
          extractedData.forEach((item) {
            Posms loadedItem = Posms.fromJson(item);
            posmList.add(loadedItem);
          });

          for (Posms posm in posmList) {
            List<String> labels = [];
            List<String> initLabel = [];
            List<List<String>> optList = [];
            posm.dropdown?.forEach((drop) {
              List<String> internalOptionList = [];
              if (drop.option != null) {
                for (var option in drop.option['option_value'].entries) {
                  internalOptionList.add(option.value);
                }
              }
              optList.add(internalOptionList);
              labels.add(drop.label!);
              initLabel.add(internalOptionList[0]);
            });
            labelList.add(labels);
            nameList.add(posm.name!);
            activityStatus.add(posm.activityStatus.toString());
            photoList.add(posm.noOfPhotos);
            Status.add(posm.statuses.toString());

            comment.add(posm.commentBox.toString());
            reportRecord.add(posm.reportRecordId.toString());
            optionsList.add(optList);
            initialList.add(initLabel);
          }
          controller = List.generate(nameList.length, (index) {
            print("controller created :${index + 1}");
            return TextEditingController();
          });

          /*print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
          print(activityStatus);
          print(reportRecord);
          print(nameList);
          print(reportRecord);
          print(storeId);
          print(workingId);
          print(companyId);
          print("********************************");*/

          notifyListeners();
        }
      }
    } on TimeoutException {
      throw "Slow internet connection";
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  void changePosmStatus(int posmStatusInd) {
    activityStatus.forEach((element) {
      print(element);
    });
    activityStatus.removeAt(posmStatusInd);
    activityStatus.insert(posmStatusInd, "1");
    notifyListeners();
    // List<PosmModel>? currentList = posmDataMap[posmKey];
    // Posms? existingItem = posmList[posmInd];
    // posmList.firstWhere((element) => element.posmId == posmid);
    // int existingIndex =
    //     currentList.indexWhere((element) => element.posmId == posmid);
    // existingItem.implemented = statusValue;
    // posmList[posmInd]
    // posmDataMap[posmKey]!.removeWhere((element) => element.posmId == posmid);
    // posmDataMap[posmKey]!.insert(existingIndex, existingItem);
    // notifyListeners();
  }
/*
  void changePosmReason(String posmKey, String reasonid, String posmid) {
    List<PosmModel>? currentList = posmDataMap[posmKey];
    PosmModel? existingItem =
        currentList!.firstWhere((element) => element.posmId == posmid);
    int existingIndex =
        currentList.indexWhere((element) => element.posmId == posmid);
    existingItem.notImplementReason = reasonid;
    posmDataMap[posmKey]!.removeWhere((element) => element.posmId == posmid);
    posmDataMap[posmKey]!.insert(existingIndex, existingItem);
    notifyListeners();
  }*/

  Future<void> fetchPosmReasons(String userName, String workingId,
      String storeId, String companyId, String clientVisitType) async {
    final url = Uri.parse(Api.getPosmReason);

    final response = await http
        .post(url,
            body: PosmConverter.postPosmReasonJson(
                userName, workingId, storeId, companyId, clientVisitType))
        .timeout(const Duration(seconds: 45));
    if (response.body.isNotEmpty) {
      final responseData = jsonDecode(response.body);
      if (responseData["isAction"]) {
        final extractedData = responseData["data"];

        List<PosmReasonModel> loadedItems = [
          PosmReasonModel(reasonId: "0", reasonName: "--Reason--")
        ];
        extractedData.forEach((item) {
          loadedItems.insert(0, PosmReasonModel.fromJson(item));
        });
        posmReasons = loadedItems;

        notifyListeners();
      }
    }
  }

  PosmReasonModel findPosmReason(String posmId) {
    return posmReasons.firstWhere((element) => element.reasonId == posmId);
  }

  Future<Map<String, dynamic>> updatePosmProject(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String reportRecordId,
      String visitType,
      String statuses,
      String comment) async {
    final url = Uri.parse(Api.updatePosmProjectReport);

    // return {"isAction": false, "msg": "dummy message"};

    try {
      final response = await http
          .post(url,
              body: PosmConverter.updatePosmJson(username, workingId, storeId,
                  companyId, reportRecordId, visitType, statuses, comment))
          .timeout(const Duration(seconds: 45));
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData["isAction"]) {
          // changePosmTableActivityStatus("88", reportRecordId);
        }
        return responseData;
      }

      return {
        "isAction": false,
        "msg": "Please contact to the development team"
      };
    } on TimeoutException {
      throw "Slow internet connection";
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> uploadPosmPhoto(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String photoImage,
      String clientVisitType,
      String posmKey,
      String reportRecordId) async {
    final url = Uri.parse(Api.uploadPosmPhoto);

    try {
      final response = await http
          .post(url,
              body: PosmConverter.postPosmPhotoJson(
                  username,
                  workingId,
                  storeId,
                  companyId,
                  photoImage,
                  clientVisitType,
                  reportRecordId))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);

        if (responseData["isAction"]) {
          // incrementAndDecrementPhotoNo(posmKey, reportRecordId, true);
          return true;
        }
        return false;
      }
      return false;
    } on TimeoutException {
      throw "Slow internet connection";
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> fetchPosmPhotos(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String clientVisitType,
      String reportRecordId) async {
    print(username);
    print(workingId);
    print(storeId);
    print(companyId);
    print(clientVisitType);
    print(reportRecordId);

    final url = Uri.parse(Api.getPosmPhotosUrl);
    try {
      final response = await http
          .post(url,
              body: PosmConverter.fetchPosmCapturePhotoJson(username, workingId,
                  storeId, companyId, clientVisitType, reportRecordId))
          .timeout(const Duration(seconds: 45));
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        List<PosmPhotoModel> loadedData = [];
        if (responseData["isAction"]) {
          final extractedData = responseData["data"];
          extractedData.forEach((item) {
            loadedData.insert(0, PosmPhotoModel.fromJson(item));
          });
          posmPhotoList = loadedData;
          notifyListeners();
          return true;
        }
      }
      return false;
    } on TimeoutException {
      throw "Slow internet connection";
    } on SocketException {
      throw "No internet connection";
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deletePosmCapturePhoto(
      String posmKey,
      String reportRecordId,
      int imageIndex,
      String username,
      String workingid,
      String storeid,
      String companyid,
      String imageid,
      String clientVisitType) async {
    final url = Uri.parse(Api.deletePosmPhotoUrl);

    try {
      final response = await http
          .post(url,
              body: PosmConverter.deletePosmCapturePhotoJson(username,
                  workingid, storeid, companyid, imageid, clientVisitType))
          .timeout(const Duration(seconds: 45));

      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        if (responseData["isAction"]) {
          posmPhotoList.removeAt(imageIndex);
          // incrementAndDecrementPhotoNo(posmKey, reportRecordId, false);

          return true;
        }
        return false;
      }
      return false;
    } catch (error) {
      rethrow;
    }
  }

  void incrementPhotoNo(int photoInd) {
    int currentPhoto = photoList[photoInd] + 1;
    photoList.removeAt(photoInd);
    photoList.insert(photoInd, currentPhoto);
    notifyListeners();
  }

  void decrementPhotoNo(int photoInd) {
    print(photoInd);
    int currentPhoto = photoList[photoInd] - 1;
    photoList.removeAt(photoInd);
    photoList.insert(photoInd, currentPhoto);
    notifyListeners();
  }

  //
  // void incrementAndDecrementPhotoNo(
  //     String posmKey, String reportRecordid, bool isIncrement) {
  //   // This method will just increment and photo in posmMap on the basis of above boolean isIncrement
  //
  //   List<PosmModel>? currentList = posmDataMap[posmKey];
  //   /*   PosmModel? existingItem = currentList!
  //       .firstWhere((element) => element.reportRecordId == reportRecordid);
  //   int existingIndex = currentList
  //       .indexWhere((element) => element.reportRecordId == reportRecordid);
  //   if (isIncrement) {
  //     existingItem.photos = existingItem.photos + 1;
  //   } else {
  //     existingItem.photos = existingItem.photos - 1;
  //   }
  //   posmDataMap[posmKey]!
  //       .removeWhere((element) => element.reportRecordId == reportRecordid);
  //   posmDataMap[posmKey]!.insert(existingIndex, existingItem);*/
  //   notifyListeners();
  // }
  //
  // void changePosmTableActivityStatus(String posmKey, String reportRecordid) {
  //   // This method will just increment and photo in posmMap on the basis of above boolean isIncrement
  //
  //   List<PosmModel>? currentList = posmDataMap[posmKey];
  //   /*PosmModel? existingItem = currentList!
  //       .firstWhere((element) => element.reportRecordId == reportRecordid);
  //   int existingIndex = currentList
  //       .indexWhere((element) => element.reportRecordId == reportRecordid);
  //
  //   existingItem.activityStatus = "1";
  //
  //   posmDataMap[posmKey]!
  //       .removeWhere((element) => element.reportRecordId == reportRecordid);
  //   posmDataMap[posmKey]!.insert(existingIndex, existingItem);*/
  //   notifyListeners();
  // }
}
