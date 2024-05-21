class PosmConverter {
  static Map<String, dynamic> postInputToJson(String username, String workingId,
      String storeId, String companyId, String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": username,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "client_visit_type": clientVisitType
    };
    return myMap;
  }

  static Map<String, dynamic> postPosmReasonJson(
      String username,
      String workingid,
      String storeId,
      String companyId,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": username,
      "working_id": workingid,
      "store_id": storeId,
      "company_id": companyId,
      "client_visit_type": clientVisitType
    };
    return myMap;
  }

  static Map<String, dynamic> updatePosmJson(
      String username,
      String workingid,
      String storeId,
      String companyId,
      String reportRecordId,
      String clientVisitType,
      String statuses,
      String comment) {
    Map<String, dynamic> myMap = {
      "username": username,
      "working_id": workingid,
      "store_id": storeId,
      "company_id": companyId,
      "report_record_id": reportRecordId,
      "client_visit_type": clientVisitType,
      "statuses": statuses,
      "comment_box": comment,
    };
    return myMap;
  }

  static Map<String, dynamic> postPosmPhotoJson(
      String username,
      String workingid,
      String storeId,
      String companyId,
      String photo,
      String clientVisitType,
      String reportRecordId) {
    Map<String, dynamic> myMap = {
      "username": username,
      "working_id": workingid,
      "store_id": storeId,
      "company_id": companyId,
      "photo_image": photo,
      "client_visit_type": clientVisitType,
      "report_record_id": reportRecordId
    };
    return myMap;
  }

  static Map<String, dynamic> fetchPosmCapturePhotoJson(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String clientVisitType,
      String reportRecordId) {
    Map<String, dynamic> myMap = {
      "username": userName,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "client_visit_type": clientVisitType,
      "report_record_id": reportRecordId
    };
    return myMap;
  }

  static Map<String, dynamic> deletePosmCapturePhotoJson(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String imageId,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": username,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "image_id": imageId,
      "client_visit_type": clientVisitType,
    };
    return myMap;
  }
}
