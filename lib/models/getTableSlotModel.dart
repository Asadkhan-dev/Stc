// To parse this JSON data, do
//
//     final getTableSlotModel = getTableSlotModelFromJson(jsonString);

import 'dart:convert';

GetTableSlotModel getTableSlotModelFromJson(String str) =>
    GetTableSlotModel.fromJson(json.decode(str));

String getTableSlotModelToJson(GetTableSlotModel data) =>
    json.encode(data.toJson());

class GetTableSlotModel {
  GetTableSlotModel({
    required this.workingId,
    required this.companyId,
    required this.slotUtilizingId,
    required this.storeId,
    required this.tableTypeId,
    required this.tableNameId,
    required this.tableType,
    required this.tableName,
    required this.slotNo,
    required this.status,
    required this.notWorkingCheck,
    required this.reason,
    required this.securityToolId,
    required this.skuId,
    required this.price,
    required this.activityStatus,
  });

  int workingId;
  int companyId;
  int slotUtilizingId;

  int storeId;
  int tableTypeId;
  int tableNameId;

  String tableType;
  String tableName;
  int slotNo;
  int status;
  int notWorkingCheck;
  int reason;
  int securityToolId;
  int skuId;
  double price;
  int activityStatus;

  factory GetTableSlotModel.fromJson(Map<String, dynamic> json) =>
      GetTableSlotModel(
        companyId: json["company_id"],
        workingId: json["working_id"],
        slotUtilizingId: json["slot_utilizing_id"],
        storeId: json["store_id"],
        tableTypeId: json["table_type_id"],
        tableNameId: json["table_name_id"],
        tableType: json["table_type"],
        tableName: json["table_name"],
        slotNo: json["slot_no"],
        status: json["status"],
        notWorkingCheck: json["not_working_check"],
        reason: json["reason"],
        securityToolId: json["security_tool_id"],
        skuId: json["sku_id"],
        price: json["price"],
        activityStatus: json["activity_status"],
      );

  Map<String, dynamic> toJson() => {
        "company_id": companyId,
        "working_id": workingId,
        "slot_utilizing_id": slotUtilizingId,
        "store_id": storeId,
        "table_type_id": tableTypeId,
        "table_name_id": tableNameId,
        "table_type": tableType,
        "table_name": tableName,
        "slot_no": slotNo,
        "status": status,
        "not_working_check": notWorkingCheck,
        "reason": reason,
        "security_tool_id": securityToolId,
        "sku_id": skuId,
        "price": price,
        "activity_status": activityStatus,
      };
}
