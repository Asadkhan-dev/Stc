import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import '../../provider/getstoretables.dart';
import '../../screens/toastmessage.dart';
import '../lodingpage.dart';
import '../signaturepad.dart';
import 'activity_list.dart';

class ActivityListScreen extends StatefulWidget {
  static const routeName = "activity-lst";
  ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  bool _isLoading = false;
  bool inIt = true;
  var routeArgs;

  @override
  void didChangeDependencies() async {
    if (inIt) {
      routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      try {
        await Provider.of<StoreTablesProvider>(context)
            .fetchTables(
                routeArgs["userName"],
                routeArgs["workingId"].toString(),
                routeArgs["storeId"].toString(),
                routeArgs["companyId"].toString(),
                routeArgs["clientVisitType"].toString())
            .then((value) {
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      } catch (error) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        showingToastMessage.ErrorToast(error.toString(), context);
      }
    }

    inIt = false;
    super.didChangeDependencies();
  }

  Future btm(
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

  void confirmFinishVisit(
      String userName, String workingId, String storeId, String companyId) {
    btm(userName, workingId, storeId, companyId);
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final userData = Provider.of<AuthProivder>(context, listen: false).userData;

    final storeTableData =
        Provider.of<StoreTablesProvider>(context).getstoreTableItems;

    final journeyTitle =
        Provider.of<StoreTablesProvider>(context, listen: false).getStorename;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: _isLoading
                ? MyLoadingSpinner()
                : Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          // height: height * 0.07,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Text(
                                journeyTitle!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Container(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 10,
                            ),
                            child: storeTableData.isEmpty
                                ? Center(
                                    child: Text("No table data found"),
                                  )
                                : GridView.builder(
                                    itemCount: storeTableData.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: width > 500 ? 3 : 2,
                                            crossAxisSpacing: 5.0,
                                            mainAxisSpacing: 20.0),
                                    itemBuilder: (context, i) {
                                      return ActivityList(
                                        workingId: storeTableData[i]
                                            .workingId
                                            .toString(),
                                        storeId: storeTableData[i]
                                            .storeId
                                            .toString(),
                                        tableTypeId: storeTableData[i]
                                            .tableTypeId
                                            .toString(),
                                        tableType: storeTableData[i].tableType,
                                        tableNameId: storeTableData[i]
                                            .tableNameId
                                            .toString(),
                                        tableName: storeTableData[i].tableName,
                                        noOfSlots: storeTableData[i]
                                            .noOfSlots
                                            .toString(),
                                        companyId: storeTableData[i]
                                            .companyId
                                            .toString(),
                                        performedSlots: storeTableData[i]
                                            .performedSlots
                                            .toString(),
                                        tableIcon: storeTableData[i].tableIcon,
                                        tableTypeName:
                                            storeTableData[i].tableType,
                                        clientVisitType:
                                            routeArgs["clientVisitType"]
                                                .toString(),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        storeTableData.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(width, 45),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0))),
                                  onPressed: () {
                                    confirmFinishVisit(
                                        userData!.username,
                                        routeArgs["workingId"].toString(),
                                        routeArgs["storeId"].toString(),
                                        routeArgs["companyId"].toString());
                                  },
                                  child: const Text("Finish Visit"),
                                ),
                              ),
                      ],
                    ),
                  )),
      ),
    );
  }
}
