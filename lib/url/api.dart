class Api {
  static const baseUrl = "https://stc.catalist-me.com/stcChannel_1_4";
  //static const baseUrl = "http://stc.zarqsolution.com/StcChannel_1_3";

  static const loginApi = baseUrl + "/loginUser";

  static const getJourneyPlan = baseUrl + "/getJourneyPlan";

  static const startVisit = baseUrl + "/startVisit";

  static const getStoreTables = baseUrl + "/getStoreTables";

  static const getPhotoTypes = baseUrl + "/getPhotoTypes";
// The above and below give same value but the new one is used in new version
  static const getPhotoTypesByTable = baseUrl + "/getPhotoTypesByTable";

  static const uploadPhotoActivity = baseUrl + "/uploadPhotoActivity";

  static const getTableSlot = baseUrl + "/getTableSlots";

  static const getSkUs = baseUrl + "/getSKUs";

  static const updateAllSlot = baseUrl + "/updateSlotDetailsArray";

  static const masterListElement = baseUrl + "/getMasterLists";

  static const endVisit = baseUrl + "/endVisit";

  static const getPhotos = baseUrl + "/getTableCapturePhotos";

  static const deleteImageApi = baseUrl + "/deleteCapturePhoto";

  static const statusOfQrCodeAndGallery = baseUrl + "/getTableImageAndQrStatus";

  static const postQrData = baseUrl + "/updateQrStatus";

  static const getPosmProject = baseUrl + "/getPosmProject"; // update in 1.4

  static const getPosmReason = baseUrl + "/getPosmReason"; // update in 1.4

  static const updatePosmProjectReport = baseUrl + "/updateProjectReport";

  static const uploadPosmPhoto = baseUrl + "/uploadPosmPhotoActivity";

  static const getPosmPhotosUrl = baseUrl + "/getPosmCapturePhotos";

  static const deletePosmPhotoUrl = baseUrl + "/deletePosmCapturePhoto";
}
