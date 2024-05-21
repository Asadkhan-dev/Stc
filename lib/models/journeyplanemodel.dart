// To parse this JSON data, do
//
//     final journeyPlane = journeyPlaneFromJson(jsonString);

import 'dart:convert';

JourneyPlaneModel journeyPlaneFromJson(String str) =>
    JourneyPlaneModel.fromJson(json.decode(str));

String journeyPlaneToJson(JourneyPlaneModel data, {required workingId}) =>
    json.encode(data.toJson());

class JourneyPlaneModel {
  JourneyPlaneModel(
      {required this.workingId,
      required this.workingDate,
      required this.storeName,
      required this.storeId,
      required this.gcode,
      required this.companyName,
      required this.companyId,
      required this.userId,
      required this.checkIn,
      required this.checkInGps,
      required this.checkOut,
      required this.checkInPhoto,
      required this.checkoutGps,
      required this.workingMinutes,
      required this.visitStatus,
      required this.clientVisitType});

  int workingId;
  DateTime workingDate;
  String storeName;
  int storeId;
  String gcode;
  String companyName;
  int companyId;
  int userId;
  dynamic checkIn;
  String checkInGps;
  dynamic checkOut;
  dynamic checkInPhoto;
  String checkoutGps;
  int workingMinutes;
  String visitStatus;
  int clientVisitType;

  factory JourneyPlaneModel.fromJson(Map<String, dynamic> json) =>
      JourneyPlaneModel(
          workingId: json["working_id"],
          workingDate: DateTime.parse(json["working_date"]),
          storeName: json["store_name"],
          storeId: json["store_id"],
          gcode: json["gcode"],
          companyName: json["company_name"],
          companyId: json["company_id"],
          userId: json["user_id"],
          checkIn: json["check_in"],
          checkInGps: json["check_in_gps"],
          checkOut: json["check_out"],
          checkInPhoto: json["check_in_photo"],
          checkoutGps: json["checkout_gps"],
          workingMinutes: json["working_minutes"],
          visitStatus: json["visit_status"],
          clientVisitType: json["client_visit_type"]);

  Map<String, dynamic> toJson() => {
        "working_id": workingId,
        "working_date":
            "${workingDate.year.toString().padLeft(4, '0')}-${workingDate.month.toString().padLeft(2, '0')}-${workingDate.day.toString().padLeft(2, '0')}",
        "store_name": storeName,
        "store_id": storeId,
        "gcode": gcode,
        "company_name": companyName,
        "company_id": companyId,
        "user_id": userId,
        "check_in": checkIn,
        "check_in_gps": checkInGps,
        "check_out": checkOut,
        "check_in_photo": checkInPhoto,
        "checkout_gps": checkoutGps,
        "working_minutes": workingMinutes,
        "visit_status": visitStatus,
        "client_visit_type": clientVisitType
      };
}
