import 'dart:io';

import 'package:cstore/services/imagepicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../image_converter/converter.dart';
import '../../models/imageReason.dart';
import '../../provider/getstoretables.dart';
import '../../provider/statusOfQrAndGallery.dart';
import '../../provider/tableSlotProvider.dart';
import '../../screens/toastmessage.dart';
import '../lodingpage.dart';
import '../viewphotos.dart/viewphotos.dart';
import 'table_form.dart';

class STCTable extends StatefulWidget {
  const STCTable({super.key});

  @override
  State<STCTable> createState() => _STCTableState();
}

class _STCTableState extends State<STCTable> {
  bool _isInit = true;
  bool _isLoading = false;
  bool _isImageUpload = false;
  var routeArgs;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      try {
        if (this.mounted) {
          setState(() {
            _isLoading = true;
          });
        }
        await Provider.of<TableSlotProvider>(context, listen: false)
            .fetchphotoTypes(
                routeArgs["userName"].toString(),
                routeArgs["workingId"].toString(),
                routeArgs["storeId"].toString(),
                routeArgs["companyId"].toString(),
                routeArgs["tableTypeId"].toString(),
                routeArgs["tableNameId"].toString(),
                routeArgs["clientVisitType"].toString())
            .then((value) async {
          await Provider.of<StatusOfQrAndGalleryProvider>(context,
                  listen: false)
              .fetchTableImageQrStatus(
                  routeArgs["userName"].toString(),
                  routeArgs["workingId"].toString(),
                  routeArgs["storeId"].toString(),
                  routeArgs["companyId"].toString(),
                  routeArgs["tableTypeId"].toString(),
                  routeArgs["tableNameId"].toString(),
                  routeArgs["clientVisitType"].toString())
              .then((value) {
            if (this.mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
        });
      } catch (error) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
          showingToastMessage.ErrorToast(error.toString(), context);
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  int photoTypeId = 0;

  void _settingModalBottomSheet(context, List<ImageReasonModel> lst) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select reason for capturing image",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: lst.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(lst[i].photoTypeName.toString()),
                        onTap: () async {
                          photoTypeId = lst[i].photoTypeId;

                          Navigator.of(context, rootNavigator: true).pop();

                          await ImageTakingService.imageSelect().then((value) {
                            _submitImage(value);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  void _submitImage(File? img) async {
    if (img != null) {
      if (this.mounted) {
        setState(() {
          _isImageUpload = true;
        });
      }
      try {
        await ImageConverter.imageToBytes(img).then((value) async {
          await Provider.of<StoreTablesProvider>(context, listen: false)
              .uploadTableImage(
                  routeArgs["userName"].toString(),
                  routeArgs["workingId"].toString(),
                  routeArgs["storeId"].toString(),
                  routeArgs["companyId"].toString(),
                  routeArgs["tableTypeId"].toString(),
                  photoTypeId.toString(),
                  value,
                  routeArgs["tableNameId"].toString(),
                  routeArgs["clientVisitType"].toString())
              .then((value) {
            if (value) {
              if (this.mounted) {
                setState(() {
                  _isImageUpload = false;
                });
              }
              Provider.of<StatusOfQrAndGalleryProvider>(context, listen: false)
                  .incrementImageCount();
              showingToastMessage.customToast(
                  "Image upload Successfully", context);
            } else {
              if (this.mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
              showingToastMessage.ErrorToast("Something went wrong", context);
            }
          });
        });
      } catch (error) {
        if (this.mounted) {
          setState(() {
            _isImageUpload = false;
          });
        }
        showingToastMessage.ErrorToast(error.toString(), context);
      }
    } else {
      // if (this.mounted) {
      //   setState(() {
      //     _isImageUpload = false;
      //   });
      return;
      // }
      // showingToastMessage.ErrorToast("Please select an image", context);
    }
  }

  void submitQrCodeData(int qrCodeValue) async {
    try {
      if (this.mounted) {
        setState(() {
          _isImageUpload = true;
        });
      }
      await Provider.of<StatusOfQrAndGalleryProvider>(context, listen: false)
          .postQrCodeData(
              routeArgs["userName"].toString(),
              routeArgs["workingId"].toString(),
              routeArgs["storeId"].toString(),
              routeArgs["companyId"].toString(),
              routeArgs["tableTypeId"].toString(),
              routeArgs["tableNameId"].toString(),
              qrCodeValue,
              routeArgs["clientVisitType"].toString())
          .then((value) {
        if (this.mounted) {
          setState(() {
            _isImageUpload = false;
          });
        }
        if (value) {
          showingToastMessage.customToast(
              "QR CODE Status Update Successfully", context);
        } else {
          showingToastMessage.ErrorToast(
              "QR CODE Status Not Update Successfully", context);
        }
      });
    } catch (error) {
      if (this.mounted) {
        setState(() {
          _isImageUpload = false;
        });
      }
      showingToastMessage.ErrorToast(error.toString(), context);
    }
  }

  void showingQrBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.only(top: 15),
            child: Wrap(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("Available"),
                  onTap: () {
                    submitQrCodeData(1);

                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    title: Text("Not Available"),
                    onTap: () {
                      submitQrCodeData(0);
                      Navigator.of(context, rootNavigator: true).pop();
                    }),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    final imageReasonList =
        Provider.of<TableSlotProvider>(context, listen: false).getImageReason;

    final imageAndQrStatusData =
        Provider.of<StatusOfQrAndGalleryProvider>(context, listen: true)
            .QrAndGalleryData;

    final journeytitle =
        Provider.of<StoreTablesProvider>(context, listen: false).getStorename;

    return _isLoading
        ? MyLoadingSpinner()
        : SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: width,
                        // height: height * 0.07,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                            Center(
                              child: Row(
                                children: [
                                  Text(
                                    journeytitle!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    routeArgs["tableType"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                ],
                              ),
                            ),
                            Container(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 50,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              routeArgs["tableName"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          _isImageUpload
                              ? Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: MyLoadingSpinner())
                              : Container(
                                  padding: EdgeInsets.only(top: 30, bottom: 30),
                                  color: Color.fromARGB(156, 217, 221, 248),
                                  child: imageReasonList!.isEmpty ||
                                          imageAndQrStatusData == null
                                      ? Center(
                                          child: Text(
                                              "Use stable internet connection and reload the page again"),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                Positioned(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showingQrBottomSheet();
                                                      },
                                                      child: Card(
                                                        elevation: 10,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.qr_code_2,
                                                              size: 40,
                                                            ),
                                                            Text("Qr Code")
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: imageAndQrStatusData
                                                              .qrActivityStatus ==
                                                          0
                                                      ? CircleAvatar(
                                                          radius: 14,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  "assets/images/activityImages/pending.png"),
                                                        )
                                                      : imageAndQrStatusData
                                                                  .qrStatus ==
                                                              1
                                                          ? CircleAvatar(
                                                              radius: 14,
                                                              child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            )
                                                          : CircleAvatar(
                                                              radius: 14,
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              height: 100,
                                              width: 100,
                                              child: GestureDetector(
                                                onTap: () {
                                                  _settingModalBottomSheet(
                                                      context, imageReasonList);
                                                },
                                                child: Card(
                                                  elevation: 10,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        size: 40,
                                                      ),
                                                      Text("Camera")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Stack(
                                              children: [
                                                Positioned(
                                                  child: Container(
                                                    height: 100,
                                                    width: 100,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                ViewPhotos
                                                                    .routeName,
                                                                arguments: {
                                                              "userName": routeArgs[
                                                                      "userName"]
                                                                  .toString(),
                                                              "workingId": routeArgs[
                                                                      "workingId"]
                                                                  .toString(),
                                                              "storeId": routeArgs[
                                                                      "storeId"]
                                                                  .toString(),
                                                              "companyId": routeArgs[
                                                                      "companyId"]
                                                                  .toString(),
                                                              "tableTypeId":
                                                                  routeArgs[
                                                                          "tableTypeId"]
                                                                      .toString(),
                                                              "tableNameId":
                                                                  routeArgs[
                                                                          "tableNameId"]
                                                                      .toString(),
                                                              "clientVisitType":
                                                                  routeArgs[
                                                                          "clientVisitType"]
                                                                      .toString()
                                                            });
                                                      },
                                                      child: Card(
                                                        elevation: 10,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.photo,
                                                              size: 40,
                                                            ),
                                                            Text("Gallery")
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            23, 162, 184, 1),
                                                    child: Text(
                                                      imageAndQrStatusData
                                                          .pictureCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: imageReasonList!.isEmpty ||
                            imageAndQrStatusData == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 120),
                            child: Center(
                              child: Text(
                                "No slots is available",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : TableSlotForm(
                            userName: routeArgs["userName"].toString(),
                            workingId: routeArgs["workingId"].toString(),
                            companyId: routeArgs["companyId"].toString(),
                            storeId: routeArgs["storeId"].toString(),
                            tableNameId: routeArgs["tableTypeId"].toString(),
                            tableTypeId: routeArgs["tableNameId"].toString(),
                            tableType: routeArgs["tableType"],
                            tableName: routeArgs["tableName"],
                            clientVisitType: routeArgs["clientVisitType"],
                          ),
                  ),
                ],
              ),
            ),
          );
  }
}
