import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cstore/posm.dart/view_posm_photo.dart';
import 'package:cstore/provider/posm_provider.dart';
import 'package:cstore/services/imagepicker.dart';
import 'package:cstore/widgets/Dropdown.dart';
import 'package:cstore/widgets/lodingpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/toastmessage.dart';
import '../widgets/signaturepad.dart';

class PosmForm extends StatefulWidget {
  static const routeName = "/posmForm";
  const PosmForm({super.key});

  @override
  State<PosmForm> createState() => _PosmFormState();
}

class _PosmFormState extends State<PosmForm> {
  final lst = ["Implement", "Not Implement"];
  bool isInit = true;
  bool isLoading = true;
  bool isLoad = false;
  bool isImageUploading = false;
  String currentReportId = "-1";
  var routeArgs;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      await Provider.of<PosmProvider>(context, listen: false)
          .fetchPosmProject(
              routeArgs["userName"],
              routeArgs["workingId"].toString(),
              routeArgs["storeId"].toString(),
              routeArgs["companyId"].toString(),
              routeArgs["clientVisitType"].toString())
          .then((_) async {
        isLoading = false;
      });
    }

    isInit = false;
  }

/*  Widget posmFormWidget(
      final int index,
      final String name,
      final String activityStatus,
      final String reportRecordId,
      final dropdown,
      final init,
      GlobalKey<FormState> formKey) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(color: Colors.deepPurple.shade50),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(name),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset(
                      width: 30,
                      height: 30,
                      activityStatus.toString() == "0"
                          ? "assets/images/activityImages/pending.png"
                          : "assets/images/activityImages/completed.png"),
                )
              ],
            )),
            SizedBox(
              height: 10,
            ),
            isLoad && currentReportId == reportRecordId
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        isImageUploading && currentReportId == reportRecordId
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await uploadImage(name, reportRecordId);
                                      },
                                      child: Card(
                                        elevation: 10,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 40,
                                            ),
                                            Text("Camera"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Positioned(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  ViewPosmPhotos.routeName,
                                                  arguments: {
                                                    "userName":
                                                        routeArgs["userName"],
                                                    "workingId":
                                                        routeArgs["workingId"]
                                                            .toString(),
                                                    "storeId":
                                                        routeArgs["storeId"]
                                                            .toString(),
                                                    "companyId":
                                                        routeArgs["companyId"]
                                                            .toString(),
                                                    "clientVisitType": routeArgs[
                                                            "clientVisitType"]
                                                        .toString(),
                                                    "reportRecordId":
                                                        reportRecordId,
                                                    "posmMapKey": name
                                                  });
                                            },
                                            child: Card(
                                              elevation: 10,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.photo,
                                                    size: 40,
                                                  ),
                                                  Text("Gallery"),
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
                                              Color.fromRGBO(23, 162, 184, 1),
                                          child: Text(
                                            "Photo String",
                                            //initialPosm.photos.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  // Container(
                                  //   height: 100,
                                  //   width: 100,
                                  //   child: GestureDetector(
                                  //     onTap: () {},
                                  //     child: Card(
                                  //       elevation: 10,
                                  //       child: Column(
                                  //         mainAxisAlignment: MainAxisAlignment.center,
                                  //         children: [
                                  //           Align(
                                  //             alignment: Alignment.topRight,
                                  //             child: CircleAvatar(
                                  //               radius: 10,
                                  //             ),
                                  //           ),
                                  //           Icon(
                                  //             Icons.photo,
                                  //             size: 40,
                                  //           ),
                                  //           Text("Gallery")
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }*/

  Future<void> uploadImage(
      String posmMapKey, String reportRecordid, int photoind) async {
    await ImageTakingService.imageSelect().then((imageFile) {
      if (imageFile == null) {
        return;
      }
      try {
        convertToBytes(imageFile).then((stringImage) async {
          setState(() {
            isImageUploading = true;
            currentReportId = reportRecordid;
          });
          await Provider.of<PosmProvider>(context, listen: false)
              .uploadPosmPhoto(
                  routeArgs["userName"],
                  routeArgs["workingId"].toString(),
                  routeArgs["storeId"].toString(),
                  routeArgs["companyId"].toString(),
                  stringImage,
                  routeArgs["clientVisitType"].toString(),
                  posmMapKey,
                  reportRecordid)
              .then((value) {
            setState(() {
              isImageUploading = false;
            });
            if (value) {
              showingToastMessage.customToast(
                  "Image upload successfully", context);
              Provider.of<PosmProvider>(context, listen: false)
                  .incrementPhotoNo(photoind);
            } else {
              showingToastMessage.ErrorToast(
                  "Image is not upload, please contact to the team", context);
            }
          });
        });
      } catch (error) {
        setState(() {
          isImageUploading = false;
        });
        showingToastMessage.ErrorToast(error.toString(), context);
      }
    });
  }

  Future<String> convertToBytes(File? pickedImage) async {
    Uint8List imagebytes = await pickedImage!.readAsBytes();
    var base64String = base64.encode(imagebytes);
    return base64String;
  }

  Future confirmFinishVisit(
      String userName, String workingId, String storeId, String companyId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure, you want to finish the visit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(SignaturePad.routeName, arguments: {
                  "userName": userName,
                  "workingId": workingId,
                  "storeId": storeId,
                  "companyId": companyId,
                  "clientVisitType": routeArgs["clientVisitType"].toString()
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Keyboard appears
      } else {
        // Keyboard dismissed
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_______________________Build status_______________________");
    final init = Provider.of<PosmProvider>(context, listen: true).initialList;
    final lable = Provider.of<PosmProvider>(context, listen: true).labelList;
    final name = Provider.of<PosmProvider>(context, listen: true).nameList;
    final activitystaus =
        Provider.of<PosmProvider>(context, listen: true).activityStatus;
    final photoList =
        Provider.of<PosmProvider>(context, listen: true).photoList;
    final status = Provider.of<PosmProvider>(context, listen: true).Status;
    final commentbox = Provider.of<PosmProvider>(context, listen: true).comment;
    final record_report_id =
        Provider.of<PosmProvider>(context, listen: true).reportRecord;
    final dropdownvales =
        Provider.of<PosmProvider>(context, listen: true).optionsList;
    final editing_controller =
        Provider.of<PosmProvider>(context, listen: true).controller;
    print(editing_controller);

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: MyLoadingSpinner())
            : Center(
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )),
                          Text(
                            routeArgs["storeName"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    name.isEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: Center(
                                  child: Text(
                                    "No posm activity is found",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: Center(
                                  child: Text(
                                    "Please Reload",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: name.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                                  return Stack(children: [
                                    Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            name[index],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: lable[index].length,
                                              itemBuilder: (context, index1) {
                                                print(
                                                    "|||||||||||||||||||||||||||||||||");
                                                return Builder(
                                                    builder: (context) {
                                                  return FormDropDown(
                                                    labletext: lable[index]
                                                        [index1],
                                                    selectedValue: init[index]
                                                        [index1],
                                                    itemList:
                                                        dropdownvales[index]
                                                            [index1],
                                                    onChange: (String value) {
                                                      init[index][index1] =
                                                          value;
                                                    },
                                                  );
                                                });
                                              }),
                                          Container(
                                            height: 100,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Card(
                                              borderOnForeground: true,
                                              color: Color.fromRGBO(255, 255,
                                                  255, 0.050980392156862744),
                                              child: TextFormField(
                                                onTapOutside: (event) =>
                                                    FocusScope.of(context)
                                                        .unfocus(),
                                                textInputAction:
                                                    TextInputAction.search,
                                                textAlign: TextAlign.justify,
                                                controller:
                                                    editing_controller[index],
                                                maxLines: 3,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        ' Write comment here...',
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.all(10)),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          isImageUploading &&
                                                  currentReportId ==
                                                      record_report_id[index]
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await uploadImage(
                                                              name[index],
                                                              record_report_id[
                                                                  index],
                                                              index);
                                                        },
                                                        child: Card(
                                                          elevation: 10,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                size: 40,
                                                              ),
                                                              Text("Camera"),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  ViewPosmPhotos
                                                                      .routeName,
                                                                  arguments: {
                                                                "posmIndex":
                                                                    index,
                                                                "userName":
                                                                    routeArgs[
                                                                        "userName"],
                                                                "workingId": routeArgs[
                                                                        "workingId"]
                                                                    .toString(),
                                                                "storeId": routeArgs[
                                                                        "storeId"]
                                                                    .toString(),
                                                                "companyId": routeArgs[
                                                                        "companyId"]
                                                                    .toString(),
                                                                "clientVisitType":
                                                                    routeArgs[
                                                                            "clientVisitType"]
                                                                        .toString(),
                                                                "reportRecordId":
                                                                    record_report_id[
                                                                        index],
                                                                "posmMapKey":
                                                                    name[index]
                                                              });
                                                        },
                                                        child: Card(
                                                          elevation: 10,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .center,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  radius: 11,
                                                                  child: Text(
                                                                    photoList[
                                                                            index]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Icon(
                                                                    Icons.photo,
                                                                    size: 40,
                                                                  ),
                                                                  Text(
                                                                      "Gallery"),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                          isLoad
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      top: 7, bottom: 7),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      minimumSize: Size(
                                                          double.infinity, 40),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onPressed: () async {
                                                    if (true /*controller[index]
                                                  .value
                                                  .text
                                                  .isNotEmpty*/
                                                        ) {
                                                      commentbox[index] =
                                                          editing_controller[
                                                                  index]
                                                              .value
                                                              .text;
                                                      status[index] =
                                                          SelectedValues(lable,
                                                              init, index);
                                                      setState(() {
                                                        // isUploading = true;
                                                        isLoad = true;
                                                        currentReportId =
                                                            record_report_id[
                                                                    index]
                                                                .toString();
                                                      });

                                                      await Provider
                                                              .of<
                                                                      PosmProvider>(
                                                                  context,
                                                                  listen: false)
                                                          .updatePosmProject(
                                                              routeArgs[
                                                                  "userName"],
                                                              routeArgs[
                                                                      "workingId"]
                                                                  .toString(),
                                                              routeArgs[
                                                                      "storeId"]
                                                                  .toString(),
                                                              routeArgs[
                                                                      "companyId"]
                                                                  .toString(),
                                                              record_report_id[
                                                                      index]
                                                                  .toString(),
                                                              routeArgs[
                                                                      "clientVisitType"]
                                                                  .toString(),
                                                              status[index],
                                                              commentbox[index]
                                                                  .toString())
                                                          .then((value) {
                                                        setState(() {
                                                          isLoad = false;
                                                          currentReportId =
                                                              "-1";
                                                        });
                                                        if (value["isAction"]) {
                                                          Provider.of<PosmProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .changePosmStatus(
                                                                  index);
                                                          showingToastMessage
                                                              .customToast(
                                                                  name[index] +
                                                                      " " +
                                                                      value[
                                                                          "msg"],
                                                                  context);
                                                        } else {
                                                          showingToastMessage
                                                              .ErrorToast(
                                                                  value["msg"],
                                                                  context);
                                                        }
                                                      });
                                                    } else {
                                                      showingToastMessage
                                                          .ErrorToast(
                                                              "${name[index]} comment empty ",
                                                              context);
                                                    }
                                                  },
                                                  child: const Text("Save"),
                                                ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: 20,
                                        right: 20,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Image.asset(
                                              width: 30,
                                              height: 30,
                                              activitystaus[index].toString() ==
                                                      "0"
                                                  ? "assets/images/activityImages/pending.png"
                                                  : "assets/images/activityImages/completed.png"),
                                        ))
                                  ]);
                                })),
                    SizedBox(
                      height: 10,
                    ),
                    name.isEmpty
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                confirmFinishVisit(
                                    routeArgs["userName"],
                                    routeArgs["workingId"].toString(),
                                    routeArgs["storeId"].toString(),
                                    routeArgs["companyId"].toString());
                              },
                              child: const Text("Finish Visit"),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}

String SelectedValues(dynamic title, dynamic init, int index) {
  String Result = '';

  for (int dropdownIndex = 0;
      dropdownIndex < title[index].length;
      dropdownIndex++) {
    Result += "${init[index][dropdownIndex]},";
  }
  return Result;
}
