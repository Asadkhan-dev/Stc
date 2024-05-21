class ViewPhotosConverter {
  static Map<String, dynamic> submitDeleteMap(
      String user,
      int workingId,
      int storeId,
      int companyId,
      int tableTypeId,
      int tableNameId,
      int imageId,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": user,
      "working_id": workingId.toString(),
      "store_id": storeId.toString(),
      "company_id": companyId.toString(),
      "table_type_id": tableTypeId.toString(),
      "table_name_id": tableNameId.toString(),
      "image_id": imageId.toString(),
      "client_visit_type": clientVisitType
    };
    return myMap;
  }

  static Map<String, dynamic> createfetchPhotosMap(
      String user,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String tableNameId,
      String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": user,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "table_type_id": tableTypeId,
      "table_name_id": tableNameId,
      "client_visit_type": clientVisitType
    };
    return myMap;
  }
}
