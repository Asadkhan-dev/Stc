// To parse this JSON data, do
//
//     final posmModel = posmModelFromJson(jsonString);

import 'dart:convert';

PosmModel posmModelFromJson(String str) => PosmModel.fromJson(json.decode(str));

String posmModelToJson(PosmModel data) => json.encode(data.toJson());

class PosmModel {
  bool? isAction;
  Data? data;

  PosmModel({this.isAction, this.data});

  PosmModel.fromJson(Map<String, dynamic> json) {
    isAction = json['isAction'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isAction'] = this.isAction;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? storeId;
  int? workingId;
  List<Posms>? posms;

  Data({
    this.userId,
    this.storeId,
    this.workingId,
    this.posms,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    storeId = json['store_id'];
    workingId = json['working_id'];
    if (json['posms'] != null) {
      posms = <Posms>[];
      json['posms'].forEach((v) {
        posms!.add(new Posms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['working_id'] = this.workingId;
    if (this.posms != null) {
      data['posms'] = this.posms!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Posms {
  String? name;
  int? activityStatus;
  int noOfPhotos = 0;
  String? statuses;
  int? commentBox;
  int? reportRecordId;
  List<Dropdown>? dropdown;

  Posms(
      {this.name,
      this.dropdown,
      this.activityStatus,
      required this.noOfPhotos,
      this.statuses,
      this.commentBox,
      this.reportRecordId});

  Posms.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    activityStatus = json['activity_status'];
    statuses = json['statuses'];
    commentBox = json['comment_box'];
    reportRecordId = json['report_record_id'];
    noOfPhotos = json['photos'];
    if (json['dropdown'] != null) {
      dropdown = <Dropdown>[];
      json['dropdown'].forEach((v) {
        dropdown!.add(new Dropdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['activity_status'] = this.activityStatus;
    data['statuses'] = this.statuses;
    data['comment_box'] = this.commentBox;
    data['report_record_id'] = this.reportRecordId;
    data['photos'] = this.noOfPhotos;
    if (this.dropdown != null) {
      data['dropdown'] = this.dropdown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dropdown {
  String? label;
  dynamic option;

  Dropdown({this.label, this.option});

  Dropdown.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.option != null) {
      data['option'] = this.option!.toJson();
    }
    return data;
  }
}
