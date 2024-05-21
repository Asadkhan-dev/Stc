// To parse this JSON data, do
//
//     final statusOfQrandGalleryModel = statusOfQrandGalleryModelFromJson(jsonString);

import 'dart:convert';

StatusOfQrandGalleryModel statusOfQrandGalleryModelFromJson(String str) =>
    StatusOfQrandGalleryModel.fromJson(json.decode(str));

String statusOfQrandGalleryModelToJson(StatusOfQrandGalleryModel data) =>
    json.encode(data.toJson());

class StatusOfQrandGalleryModel {
  StatusOfQrandGalleryModel({
    required this.pictureCount,
    required this.qrActivityStatus,
    required this.qrStatus,
  });

  int pictureCount;
  int qrActivityStatus;
  int qrStatus;

  factory StatusOfQrandGalleryModel.fromJson(Map<String, dynamic> json) =>
      StatusOfQrandGalleryModel(
        pictureCount: json["pictureCount"],
        qrActivityStatus: json["qr_activity_status"],
        qrStatus: json["qr_status"],
      );

  Map<String, dynamic> toJson() => {
        "pictureCount": pictureCount,
        "qr_activity_status": qrActivityStatus,
        "qr_status": qrStatus,
      };
}
