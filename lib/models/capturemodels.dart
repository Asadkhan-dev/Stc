// To parse this JSON data, do
//
//     final capturePhotosModel = capturePhotosModelFromJson(jsonString);

import 'dart:convert';

CapturePhotosModel capturePhotosModelFromJson(String str) =>
    CapturePhotosModel.fromJson(json.decode(str));

String capturePhotosModelToJson(CapturePhotosModel data) =>
    json.encode(data.toJson());

class CapturePhotosModel {
  CapturePhotosModel({
    required this.imageId,
    required this.type,
    required this.image,
    required this.storeId,
    required this.companyId,
    required this.tableTypeId,
    required this.tableNameId,
    required this.workingId,
  });

  int imageId;
  String type;
  String image;
  int storeId;
  int companyId;
  int tableTypeId;
  int tableNameId;
  int workingId;

  factory CapturePhotosModel.fromJson(Map<String, dynamic> json) =>
      CapturePhotosModel(
        imageId: json["image_id"],
        type: json["type"],
        image: json["image"],
        storeId: json["store_id"],
        companyId: json["company_id"],
        tableTypeId: json["table_type_id"],
        tableNameId: json["table_name_id"],
        workingId: json["working_id"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "type": type,
        "image": image,
        "store_id": storeId,
        "company_id": companyId,
        "table_type_id": tableTypeId,
        "table_name_id": tableNameId,
        "working_id": workingId,
      };
}
