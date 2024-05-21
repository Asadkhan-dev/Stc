class Finishconverter {
  static Map<String, dynamic> createFinishJson(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String signImageText,
      String commentText,
      String lat,
      String long,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": userName,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "sign_image": signImageText,
      "visit_comment": commentText,
      "check_out_gps": "$lat,$long",
      "client_visit_type": clientVisitType
    };
    return myMap;
  }
}
