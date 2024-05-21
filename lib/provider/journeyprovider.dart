import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/journeyplanemodel.dart';
import '../url/api.dart';

class JourneyProvider with ChangeNotifier {
  List<JourneyPlaneModel> _journeyItems = [];

  List<JourneyPlaneModel> get getJourneyItems {
    return [..._journeyItems];
  }

  Future<void> fetchJourneyPlane(String username) async {
    final url = Uri.parse(Api.getJourneyPlan);

    try {
      final response = await http.post(url,
          body: {"username": username}).timeout(const Duration(seconds: 45));
      _journeyItems = [];
      if (response.body.isNotEmpty) {
        final responseData = json.decode(response.body);

        if (responseData["isAction"]) {
          final journeypln = responseData["data"];

          List<JourneyPlaneModel> loadedItems = [];
          journeypln.forEach((itemData) {
            loadedItems.insert(0, JourneyPlaneModel.fromJson(itemData));
          });
          _journeyItems = loadedItems;
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

  JourneyPlaneModel findJourneyPlane(int workId) {
    return _journeyItems.firstWhere((element) => element.workingId == workId);
  }

  void changeVisitStatus(int workId) {
    final journeyelement =
        _journeyItems.firstWhere((element) => element.workingId == workId);
    final elementIndex =
        _journeyItems.indexWhere((element) => element.workingId == workId);
    _journeyItems.removeAt(elementIndex);
    journeyelement.visitStatus = "IN PROGRESS";
    _journeyItems.insert(elementIndex, journeyelement);
    notifyListeners();
  }
}
