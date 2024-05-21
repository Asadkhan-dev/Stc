// To parse this JSON data, do
//
//     final securityToolModel = securityToolModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/src/material/dropdown.dart';

SecurityToolModel? securityToolModelFromJson(String str) =>
    SecurityToolModel.fromJson(json.decode(str));

String securityToolModelToJson(SecurityToolModel? data) =>
    json.encode(data!.toJson());

class SecurityToolModel {
  SecurityToolModel({
    this.securityToolId,
    this.name,
  });

  int? securityToolId;
  String? name;

  factory SecurityToolModel.fromJson(Map<String, dynamic> json) =>
      SecurityToolModel(
        securityToolId: json["security_tool_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "security_tool_id": securityToolId,
        "name": name,
      };

  map(DropdownMenuItem<String> Function(dynamic item) param0) {}
}
