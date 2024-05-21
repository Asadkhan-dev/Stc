import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../image_converter/converter.dart';
import '../../posm.dart/posm_form.dart';
import '../../provider/getstoretables.dart';
import '../../provider/journeyprovider.dart';
import '../../provider/startvisitprovider.dart';
import '../../screens/toastmessage.dart';
import '../../services/gettingGPS.dart';
import '../activityList/activitylistScreen.dart';
import '../lodingpage.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  File? _pickedImage;
  bool _isLoading = false;
  String base64String = "";
  String lat = '';
  String long = '';

  Future<void> _submitstartVisit(
      String username,
      String workingId,
      String storeId,
      String companyId,
      String photo64,
      String storeName,
      int clientVisitType) async {
    try {
      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      locationService.getLocation().then((value) async {
        lat = value["lat"];
        long = value["long"];
        if (value["locationIsPicked"]) {
          await ImageConverter.imageToBytes(_pickedImage!).then(
            (value) async {
              try {
                await Provider.of<StartVisitProvider>(context, listen: false)
                    .startVisit(
                        username,
                        workingId.toString(),
                        storeId.toString(),
                        companyId.toString(),
                        lat,
                        long,
                        value,
                        clientVisitType.toString())
                    .then((value) async {
                  if (value) {
                    Provider.of<JourneyProvider>(context, listen: false)
                        .changeVisitStatus(int.parse(workingId));
                    if (clientVisitType == 2) {
                      Navigator.of(context)
                          .pushReplacementNamed(PosmForm.routeName, arguments: {
                        "userName": username,
                        "workingId": workingId,
                        "storeId": storeId,
                        "companyId": companyId,
                        "storeName": storeName,
                        "clientVisitType": clientVisitType
                      });
                    } else {
                      Navigator.of(context).pushReplacementNamed(
                          ActivityListScreen.routeName,
                          arguments: {
                            "userName": username,
                            "workingId": workingId,
                            "storeId": storeId,
                            "companyId": companyId,
                            "clientVisitType": clientVisitType
                          });
                    }

                    return;
                  } else {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                      showingToastMessage.ErrorToast(
                          "Visit is not started please, contact with the development team",
                          context);
                    }
                  }
                });
              } catch (error) {
                if (this.mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                  showingToastMessage.ErrorToast(error.toString(), context);
                  return;
                }
              }
            },
          );
        } else {
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
            showingToastMessage.ErrorToast(
                "Please, turn on your device location or allow it from settings",
                context);
          }
        }
      });
    } catch (error) {
      showingToastMessage.ErrorToast(error.toString(), context);
    }
  }

  Future<void> convertToBytes() async {
    Uint8List imagebytes = await _pickedImage!.readAsBytes();
    base64String = base64.encode(imagebytes);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;

    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _pickedImage = routeArgs["image"];

    final journeytitle = routeArgs["journeyTitle"];

    return _isLoading
        ? MyLoadingSpinner()
        : SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      // height: height * 0.07,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                          Center(
                            child: Text(
                              journeytitle,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ),
                          Container()
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: height * 0.6,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Image.file(
                        _pickedImage!,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image.asset(
                                width: 40,
                                height: 40,
                                "assets/images/cancel.jpg"),
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<StoreTablesProvider>(context,
                                      listen: false)
                                  .setStoreName(journeytitle);

                              print(routeArgs["userName"].toString());
                              print(routeArgs["workingid"].toString());
                              print(routeArgs["storeId"].toString());
                              print(routeArgs["companyId"].toString());
                              _submitstartVisit(
                                  routeArgs["userName"].toString(),
                                  routeArgs["workingid"].toString(),
                                  routeArgs["storeId"].toString(),
                                  routeArgs["companyId"].toString(),
                                  base64String,
                                  routeArgs["journeyTitle"],
                                  int.parse(
                                      routeArgs["clientVisitType"].toString()));
                            },
                            child: Image.asset(
                                width: 40,
                                height: 40,
                                "assets/images/completed.png"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
