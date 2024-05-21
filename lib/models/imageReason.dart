// To parse this JSON data, do
//
//     final imageReasonModel = imageReasonModelFromJson(jsonString);

import 'dart:convert';

ImageReasonModel imageReasonModelFromJson(String str) =>
    ImageReasonModel.fromJson(json.decode(str));

String imageReasonModelToJson(ImageReasonModel data) =>
    json.encode(data.toJson());

class ImageReasonModel {
  ImageReasonModel({
    required this.photoTypeId,
    required this.photoTypeName,
  });

  int photoTypeId;
  String photoTypeName;

  factory ImageReasonModel.fromJson(Map<String, dynamic> json) =>
      ImageReasonModel(
        photoTypeId: json["photo_type_id"],
        photoTypeName: json["photo_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "photo_type_id": photoTypeId,
        "photo_type_name": photoTypeName,
      };
}
