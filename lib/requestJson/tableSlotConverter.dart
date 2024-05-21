class TableSlotConverter {
  static Map<String, dynamic> skuJson(
      String userName,
      String workingId,
      String storeId,
      String companyId,
      String tableTypeId,
      String clientVisitType) {
    Map<String, dynamic> myMapData = {
      "username": userName,
      "working_id": workingId,
      "store_id": storeId,
      "company_id": companyId,
      "table_type_id": tableTypeId,
      "client_visit_type": clientVisitType
    };
    return myMapData;
  }

  static Map<String, dynamic> createMasterString(String userName,
      String workingId, String tableTypeId, String clientVisitType) {
    Map<String, dynamic> myMap = {
      "username": userName,
      "working_id": workingId,
      "table_type_id": tableTypeId,
      "client_visit_type": clientVisitType
    };
    return myMap;
  }
}
