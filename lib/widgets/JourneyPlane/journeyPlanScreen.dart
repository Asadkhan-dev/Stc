import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import '../../provider/journeyprovider.dart';
import '../../screens/toastmessage.dart';
import '../lodingpage.dart';
import 'journey_plane.dart';

class JourneyPlaneScreen extends StatefulWidget {
  static const routeName = "journey-plane";
  JourneyPlaneScreen({super.key});

  @override
  State<JourneyPlaneScreen> createState() => _JourneyPlaneScreenState();
}

class _JourneyPlaneScreenState extends State<JourneyPlaneScreen> {
  bool isinit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (isinit) {
      if (this.mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      checkUpdate();
      final userData =
          Provider.of<AuthProivder>(context, listen: false).userData;
      try {
        await Provider.of<JourneyProvider>(context, listen: true)
            .fetchJourneyPlane(userData!.username);
      } catch (error) {
        showingToastMessage.ErrorToast(error.toString(), context);
      }
    }
    isinit = false;

    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  checkUpdate() async {
    try {
      final newVersion = NewVersion(
        iOSId: 'com.cStoreStc.cStoreStc',
        androidId: 'com.catalist.cstore',
      );

      final status = await newVersion.getVersionStatus();
      if (status != null) {
        if (status.canUpdate)
          newVersion.showUpdateDialog(
            allowDismissal: false,
            context: context,
            versionStatus: status,
            dialogTitle: 'Update',
            dialogText:
                'Please update your app to ${status.storeVersion} version',
          );
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    final journeyData =
        Provider.of<JourneyProvider>(context, listen: false).getJourneyItems;

    return _isLoading
        ? MyLoadingSpinner()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(0))),
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
                        const Text(
                          "JOURNEY PLAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  journeyData.isEmpty
                      ? Center(
                          child: Text(
                            "No Journey Plane is Available",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              itemCount: journeyData.length,
                              itemBuilder: (context, i) {
                                return JourneyPlane(
                                  storeName: journeyData[i].storeName,
                                  storeId: journeyData[i].storeId,
                                  userName: journeyData[i].userId.toString(),
                                  visitStatus: journeyData[i].visitStatus,
                                  workingId: journeyData[i].workingId,
                                  companyName: journeyData[i].companyName,
                                  companyId:
                                      journeyData[i].companyId.toString(),
                                  clientVisitType:
                                      journeyData[i].clientVisitType,
                                );
                              }),
                        ),
                ],
              ),
            ),
          );
  }
}
