import 'dart:io';
import 'dart:typed_data';

import 'package:cstore/services/gettingGPS.dart';
import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../image_converter/converter.dart';
import '../provider/finishprovider.dart';
import '../screens/toastmessage.dart';
import 'JourneyPlane/journeyPlanScreen.dart';
import 'lodingpage.dart';

class SignaturePad extends StatefulWidget {
  static const routeName = "/signature_route";
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  bool _isLoading = false;
  Uint8List? showingImage;
  var routeArgs;
  TextEditingController _textEditingController = TextEditingController();

  SignatureController signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.red,
      exportBackgroundColor: Colors.yellowAccent);

  void submitSignature(String userName, String workingId, String storeId,
      String companyId) async {
    if (_textEditingController.text.isEmpty) {
      showingToastMessage.ErrorToast("Please, enter a comment", context);
      return;
    }

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(showingImage!);

    await ImageConverter.imageToBytes(file).then((value) {
      submitFinishVisit(userName, workingId, storeId, companyId, value);
    });
  }

  void submitFinishVisit(String userName, String workingId, String storeId,
      String companyId, String imageText) async {
    print("working id");
    print(workingId);
    print("stored");
    print(storeId);
    print("company id");
    print(companyId);
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      locationService.getLocation().then((value) async {
        if (value["locationIsPicked"]) {
          await Provider.of<FinishProvider>(context, listen: false)
              .finishVisit(
                  userName,
                  workingId,
                  storeId,
                  companyId,
                  imageText,
                  _textEditingController.text,
                  value["lat"],
                  value["long"],
                  routeArgs["clientVisitType"])
              .then((value) {
            if (value["isAction"]) {
              if (this.mounted) {
                setState(() {
                  _isLoading = false;
                });
                showingToastMessage.customToast(
                    value["msg"].toString(), context);
              }
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed(JourneyPlaneScreen.routeName);
            } else {
              if (this.mounted) {
                setState(() {
                  _isLoading = false;
                });
                showingToastMessage.ErrorToast(
                    value["msg"].toString(), context);
              }
            }
          });
        } else {
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
            showingToastMessage.ErrorToast(
                "Please turn on your device location Or allow it from settings",
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
      }
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: _isLoading
          ? MyLoadingSpinner()
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.arrow_back_ios_new)),
                            Text(
                              "Signature Pad",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4, right: 4),
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          controller: _textEditingController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 226, 226, 226),
                              // contentPadding: EdgeInsets.only(top: 0, left: 10),
                              hintText: "Add a comment",
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Signature(
                            controller: signatureController,
                            width: width,
                            height: height * 0.5,
                            backgroundColor: Colors.lightBlue[100]!,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.red,
                            child: IconButton(
                              onPressed: () {
                                signatureController.clear();
                              },
                              icon: Icon(
                                Icons.settings_backup_restore_sharp,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green,
                            child: IconButton(
                              onPressed: () async {
                                showingImage =
                                    await signatureController.toPngBytes();

                                if (showingImage == null) {
                                  showingToastMessage.ErrorToast(
                                      "Please, do sign on the blue pad",
                                      context);
                                  return;
                                }
                                submitSignature(
                                    routeArgs["userName"],
                                    routeArgs["workingId"],
                                    routeArgs["storeId"],
                                    routeArgs["companyId"]);
                              },
                              icon: Icon(
                                Icons.check,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
