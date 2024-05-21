// To parse this JSON data, do
//
//     final getStoreTableModel = getStoreTableModelFromJson(jsonString);

import 'dart:convert';

GetStoreTableModel getStoreTableModelFromJson(String str) =>
    GetStoreTableModel.fromJson(json.decode(str));

String getStoreTableModelToJson(GetStoreTableModel data) =>
    json.encode(data.toJson());

class GetStoreTableModel {
  GetStoreTableModel(
      {required this.workingId,
      required this.storeId,
      required this.tableTypeId,
      required this.tableType,
      required this.tableNameId,
      required this.tableName,
      required this.noOfSlots,
      required this.performedSlots,
      required this.companyId,
      required this.tableIcon});

  int workingId;
  int storeId;
  int tableTypeId;
  String tableType;
  int tableNameId;
  String tableName;
  int noOfSlots;
  int performedSlots;
  int companyId;
  String tableIcon;

  factory GetStoreTableModel.fromJson(Map<String, dynamic> json) =>
      GetStoreTableModel(
        workingId: json["working_id"],
        storeId: json["store_id"],
        tableTypeId: json["table_type_id"],
        tableType: json["table_type"],
        tableNameId: json["table_name_id"],
        tableName: json["table_name"],
        noOfSlots: json["no_of_slots"],
        performedSlots: json["performed_slots"],
        companyId: json["company_id"],
        tableIcon: json["table_icon"],
      );

  Map<String, dynamic> toJson() => {
        "working_id": workingId,
        "store_id": storeId,
        "table_type_id": tableTypeId,
        "table_type": tableType,
        "table_name_id": tableNameId,
        "table_name": tableName,
        "no_of_slots": noOfSlots,
        "performed_slots": performedSlots,
        "company_id": companyId,
        "table_icon": tableIcon,
      };
}
