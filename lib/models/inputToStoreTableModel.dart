// To parse this JSON data, do
//
//     final inputToStoreTableModel = inputToStoreTableModelFromJson(jsonString);

import 'dart:convert';

InputToStoreTableModel inputToStoreTableModelFromJson(String str) =>
    InputToStoreTableModel.fromJson(json.decode(str));

String inputToStoreTableModelToJson(InputToStoreTableModel data) =>
    json.encode(data.toJson());

class InputToStoreTableModel {
  InputToStoreTableModel(
      {required this.username,
      required this.workingId,
      required this.storeId,
      required this.companyId,
      required this.clientVisitType});

  String username;
  String workingId;
  String storeId;
  String companyId;
  String clientVisitType;

  factory InputToStoreTableModel.fromJson(Map<String, dynamic> json) =>
      InputToStoreTableModel(
          username: json["username"],
          workingId: json["working_id"],
          storeId: json["store_id"],
          companyId: json["company_id"],
          clientVisitType: json["client_visit_type"]);

  Map<String, dynamic> toJson() => {
        "username": username,
        "working_id": workingId,
        "store_id": storeId,
        "company_id": companyId,
        "client_visit_type": clientVisitType
      };
}
