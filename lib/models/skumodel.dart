// To parse this JSON data, do
//
//     final skuModel = skuModelFromJson(jsonString);

import 'dart:convert';

SkuModel? skuModelFromJson(String str) => SkuModel.fromJson(json.decode(str));

String skuModelToJson(SkuModel? data) => json.encode(data!.toJson());

class SkuModel {
  SkuModel({
    this.skuId,
    this.skuName,
  });

  int? skuId;
  String? skuName;

  factory SkuModel.fromJson(Map<String, dynamic> json) => SkuModel(
        skuId: json["sku_id"],
        skuName: json["sku_name"],
      );

  get value => null;

  Map<String, dynamic> toJson() => {
        "sku_id": skuId,
        "sku_name": skuName,
      };
}
