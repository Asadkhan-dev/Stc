import 'package:cstore/posm.dart/posm_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/getstoretables.dart';
import '../../services/imagepicker.dart';
import '../activityList/activitylistScreen.dart';
import '../checkin/checkinScreen.dart';

class JourneyPlane extends StatefulWidget {
  final String userName;
  final String storeName;
  final int storeId;
  final int workingId;
  final String visitStatus;
  final String companyName;
  final String companyId;
  final int clientVisitType;

  const JourneyPlane(
      {super.key,
      required this.userName,
      required this.storeName,
      required this.storeId,
      required this.visitStatus,
      required this.workingId,
      required this.companyName,
      required this.companyId,
      required this.clientVisitType});

  @override
  State<JourneyPlane> createState() => _JourneyPlaneState();
}

class _JourneyPlaneState extends State<JourneyPlane> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.companyName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(79, 0, 140, 1),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.storeName),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // width: width * 0.3,
                    // height: height * 0.055,
                    width: 110,
                    height: 40,
                    decoration: widget.visitStatus == "IN PROGRESS"
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(23, 162, 184, 1),
                          )
                        : widget.visitStatus == "FINISHED"
                            ? BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10))
                            : BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(widget.visitStatus)),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : widget.visitStatus == "FINISHED"
                          ? ElevatedButton(
                              onPressed: null,
                              child: Text("COMPLETED"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: Size(width * 0.26, height * 0.06),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(79, 0, 140, 1),
                                minimumSize: Size(100, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: widget.visitStatus != "PENDING"
                                  ? () async {
                                      Provider.of<StoreTablesProvider>(context,
                                              listen: false)
                                          .setStoreName(widget.storeName);
                                      if (widget.clientVisitType == 2) {
                                        print('hello');
                                        Navigator.of(context).pushNamed(
                                            PosmForm.routeName,
                                            arguments: {
                                              "userName": widget.userName,
                                              "workingId": widget.workingId,
                                              "storeId": widget.storeId,
                                              "companyId": widget.companyId,
                                              "storeName": widget.storeName,
                                              "clientVisitType":
                                                  widget.clientVisitType
                                            });
                                      } else {
                                        Navigator.of(context).pushNamed(
                                            ActivityListScreen.routeName,
                                            arguments: {
                                              "userName": widget.userName,
                                              "workingId": widget.workingId,
                                              "storeId": widget.storeId,
                                              "companyId": widget.companyId,
                                              "clientVisitType":
                                                  widget.clientVisitType
                                            });
                                      }
                                    }
                                  : () async {
                                      await ImageTakingService.imageSelect()
                                          .then((value) {
                                        if (value != null) {
                                          print("image taking service");
                                          Navigator.of(context).pushNamed(
                                              CheckInScreen.routeName,
                                              arguments: {
                                                "userName": widget.userName,
                                                "workingid": widget.workingId,
                                                "storeId": widget.storeId,
                                                "companyId": widget.companyId,
                                                "image": value,
                                                "journeyTitle":
                                                    widget.storeName,
                                                "clientVisitType":
                                                    widget.clientVisitType
                                              });
                                        }
                                      });
                                    },
                              child: widget.visitStatus == "PENDING"
                                  ? const Text("START VISIT",
                                      style: TextStyle(color: Colors.white))
                                  : const Text(
                                      "EDIT VISIT",
                                      style: TextStyle(color: Colors.white),
                                    )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
