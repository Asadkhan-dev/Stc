

// This model is used to initialize Start visit response data to intialize

class StartVisitResponseModel {
  final String workingid;
  final String storeid;
  final String companyid;
  final bool isAction;

  StartVisitResponseModel(
      {required this.workingid,
      required this.storeid,
      required this.companyid,
      required this.isAction});
}
