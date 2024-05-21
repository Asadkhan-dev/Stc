import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import '../lodingpage.dart';
import '../stcTable/stctablescreen.dart';

class ActivityList extends StatefulWidget {
  final String workingId;
  final String storeId;
  final String tableTypeId;
  final String tableType;
  final String tableNameId;
  final String tableName;
  final String noOfSlots;
  final String performedSlots;
  final String companyId;
  final String tableIcon;
  final String tableTypeName;
  final String clientVisitType;

  const ActivityList(
      {super.key,
      required this.workingId,
      required this.storeId,
      required this.tableTypeId,
      required this.tableType,
      required this.tableNameId,
      required this.tableName,
      required this.noOfSlots,
      required this.performedSlots,
      required this.companyId,
      required this.tableIcon,
      required this.tableTypeName,
      required this.clientVisitType});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  bool _isLoading = false;
  void _submitTable() {
    final userData = Provider.of<AuthProivder>(context, listen: false).userData;
    // setState(() {
    //   _isLoading = true;
    // });
    // try {
    // await Provider.of<StoreTablesProvider>(context, listen: false)
    //     .getPhotoReason(userData!.username, widget.workingId, widget.storeId)
    //     .then((value) {
    //   if (value) {
    // setState(() {
    //   _isLoading = false;
    // });print("is this line is runnig");

    Navigator.of(context).pushNamed(STCTableScreen.routeName, arguments: {
      "userName": userData!.username,
      "workingId": widget.workingId,
      "storeId": widget.storeId,
      "companyId": widget.companyId,
      "tableTypeId": widget.tableTypeId,
      "tableNameId": widget.tableNameId,
      "tableType": widget.tableType,
      "tableName": widget.tableName,
      "clientVisitType": widget.clientVisitType
    });
    // } else {
    // setState(() {
    //   _isLoading = false;
    // });
    // showingToastMessage.ErrorToast(
    //     "Error, Some thing went wrong", context);
    // }
    // });
    // } catch (error) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   showingToastMessage.ErrorToast(error.toString(), context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    return _isLoading
        ? MyLoadingSpinner()
        : GestureDetector(
            onTap: _submitTable,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 20,
              // color: Color.fromARGB(255, 142, 60, 197),
              // color: const Color.fromRGBO(79, 0, 140, 100),
              // color: Color.fromRGBO(255, 54, 95, 1),
              color: Colors.white,

              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                              width: 30,
                              height: 30,
                              widget.performedSlots != widget.noOfSlots
                                  ? "assets/images/activityImages/pending.png"
                                  : "assets/images/activityImages/completed.png"),
                        ),
                        Container(
                          // width: width * 0.2,
                          // height: height * 0.15,
                          // width: 80,
                          // height: 80,
                          child: CachedNetworkImage(
                            imageUrl: widget.tableIcon,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          // Image.network(widget.tableIcon)
                          // Image.asset("assets/images/table.png"),
                          //   Image.network(
                          //       "https://cdn-icons-png.flaticon.com/512/333/333521.png"),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.tableTypeName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.tableName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                        Text(
                          "No of Slots : ${widget.noOfSlots}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
