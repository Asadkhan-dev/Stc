import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import '../../provider/statusOfQrAndGallery.dart';
import '../../provider/viewphotosProvider.dart';
import '../../screens/toastmessage.dart';
import '../lodingpage.dart';

class ViewPhotos extends StatefulWidget {
  static const routeName = "/viewPhotos";
  const ViewPhotos({super.key});

  @override
  State<ViewPhotos> createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  bool isInit = true;
  int activeImage = 0;
  bool _isLoading = false;
  bool showNoImageTxt = false;
  var routeArgs;

  @override
  void didChangeDependencies() async {
    if (isInit) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      try {
        routeArgs =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
        await Provider.of<ViewPhotosProvider>(context)
            .fetchPhotos(
                routeArgs["userName"].toString(),
                routeArgs["workingId"].toString(),
                routeArgs["storeId"].toString(),
                routeArgs["companyId"].toString(),
                routeArgs["tableTypeId"].toString(),
                routeArgs["tableNameId"].toString(),
                routeArgs["clientVisitType"].toString())
            .then((value) {
          if (value) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            showingToastMessage.ErrorToast("No image is loaded", context);
          }
        });
      } catch (error) {
        showingToastMessage.ErrorToast(error.toString(), context);
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future deleteImageConfirmation(
      int imageIndex,
      String user,
      int workingId,
      int storeId,
      int companyId,
      int tableTypeId,
      int tableNameId,
      int imageId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure, you want to delete this image?'),
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
                deleteImage(imageIndex, user, workingId, storeId, companyId,
                    tableTypeId, tableNameId, imageId);
              },
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
  }

  void deleteImage(int imageIndex, String user, int workingId, int storeId,
      int companyId, int tableTypeId, int tableNameId, int imageId) async {
    if (imageIndex > 0) {
      activeImage = activeImage - 1;
    }

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await Provider.of<ViewPhotosProvider>(context, listen: false)
          .deleteCaputreImage(imageIndex, user, workingId, storeId, companyId,
              tableTypeId, tableNameId, imageId, routeArgs["clientVisitType"])
          .then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        if (!value) {
          showingToastMessage.ErrorToast(
              "Ops, Image does not deleted", context);
          return;
        }
        Provider.of<StatusOfQrAndGalleryProvider>(context, listen: false)
            .decrementImageCount();

        showingToastMessage.customToast("Image delete successfully", context);
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      showingToastMessage.ErrorToast(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userData = Provider.of<AuthProivder>(context, listen: false).userData;
    final imageData =
        Provider.of<ViewPhotosProvider>(context, listen: false).getcaptureItem;

    return Scaffold(
      body: _isLoading
          ? MyLoadingSpinner()
          : showNoImageTxt
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No Image available"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Go Back"))
                    ],
                  ),
                )
              : SafeArea(
                  child: imageData!.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No image is here",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Go Back"))
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.arrow_back_ios)),
                                Container(
                                  child: Text(
                                    imageData[activeImage].type,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                    onPressed: () {
                                      deleteImageConfirmation(
                                          activeImage,
                                          userData!.username,
                                          imageData[activeImage].workingId,
                                          imageData[activeImage].storeId,
                                          imageData[activeImage].companyId,
                                          imageData[activeImage].tableTypeId,
                                          imageData[activeImage].tableNameId,
                                          imageData[activeImage].imageId);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                height: height * 0.65,
                                margin: EdgeInsets.only(
                                    top: 10, right: 10, left: 10, bottom: 15),
                                child: PhotoView(
                                  imageProvider: NetworkImage(
                                    imageData[activeImage].image,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: imageData.length,
                                  itemBuilder: (ctx, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            activeImage = i;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        decoration: activeImage == i
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    width: 4,
                                                    color: Color.fromRGBO(
                                                        79, 0, 140, 1)))
                                            : BoxDecoration(),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: imageData[i].image,
                                            height: height * 0.1,
                                            width: width * 0.25,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                ),
    );
  }
}
