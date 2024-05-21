// To parse this JSON data, do
//
//     final reasonModel = reasonModelFromJson(jsonString);

import 'dart:convert';

ReasonModel? reasonModelFromJson(String str) =>
    ReasonModel.fromJson(json.decode(str));

String reasonModelToJson(ReasonModel? data) => json.encode(data!.toJson());

class ReasonModel {
  ReasonModel({
    this.reason,
    this.reasonName,
  });

  int? reason;
  String? reasonName;

  factory ReasonModel.fromJson(Map<String, dynamic> json) => ReasonModel(
        reason: json["reason"],
        reasonName: json["reason_name"],
      );

  Map<String, dynamic> toJson() => {
        "reason": reason,
        "reason_name": reasonName,
      };
}
