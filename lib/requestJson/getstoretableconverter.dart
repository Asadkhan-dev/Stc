class GetStoreTableConverter {
  static Map<String, dynamic> uploadImageToJson(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String photoTypeId,
      String photoImage,
      String tableNameId,
      String clientVisitType) {
    Map<String, dynamic> mapData = {
      "username": username,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "table_type_id": tableTypeId,
      "photo_type_id": photoTypeId,
      "photo_image": photoImage,
      "table_name_id": tableNameId,
      "client_visit_type": clientVisitType
    };
    return mapData;
  }
}
