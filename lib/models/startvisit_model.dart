// This mode is used to initialize that data which is giving to startvisit Api

// String startVisitModelToJson(StartVisitModel data) =>
//     json.encode(data.toJson());

class StartVisitModel {
  StartVisitModel({
    required this.username,
    required this.workingId,
    required this.storeId,
    required this.companyId,
    required this.checkInGps,
    required this.photoImage,
  });

  String username;
  String workingId;
  String storeId;
  String companyId;
  String checkInGps;
  String photoImage;

  factory StartVisitModel.fromJson(Map<String, dynamic> json) =>
      StartVisitModel(
        username: json["username"],
        workingId: json["working_id"],
        storeId: json["store_id"],
        companyId: json["company_id"],
        checkInGps: json["check_in_gps"],
        photoImage: json["photoImage"],
      );

  static Map<String, dynamic> createjson(String name, String workid,
      String stid, String compid, String gps, String img, String visitType) {
    final Map<String, dynamic> myMap = {
      "username": name,
      "working_id": workid,
      "store_id": stid,
      "company_id": compid,
      "check_in_gps": gps,
      "photoImage": img,
      "client_visit_type": visitType
    };
    return myMap;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["username"] = username;
    data["working_id"] = workingId;
    data["store_id"] = storeId;
    data["company_id"] = companyId;
    data["check_in_gps"] = checkInGps;
    data["photoImage"] = photoImage;
    // "username": username,
    // "working_id": workingId,
    // "store_id": storeId,
    // "company_id": companyId,
    // "check_in_gps": checkInGps,
    // "photoImage": photoImage,
    return data;
  }
}
