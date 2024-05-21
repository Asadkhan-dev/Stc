import 'dart:convert';

PosmReasonModel posmReasonModelFromJson(String str) =>
    PosmReasonModel.fromJson(json.decode(str));

String posmReasonModelToJson(PosmReasonModel data) =>
    json.encode(data.toJson());

class PosmReasonModel {
  final String reasonId;
  final String reasonName;

  PosmReasonModel({
    required this.reasonId,
    required this.reasonName,
  });

  factory PosmReasonModel.fromJson(Map<String, dynamic> json) =>
      PosmReasonModel(
        reasonId: json["reason_id"].toString(),
        reasonName: json["reason_name"],
      );

  Map<String, dynamic> toJson() => {
        "reason_id": reasonId,
        "reason_name": reasonName,
      };
}
