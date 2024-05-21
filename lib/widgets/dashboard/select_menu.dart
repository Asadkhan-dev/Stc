import 'package:flutter/material.dart';

import '../../screens/toastmessage.dart';
import '../JourneyPlane/journeyPlanScreen.dart';
import 'logout.dart';

class SelectMenu extends StatelessWidget {
  final String userName;

  SelectMenu({required this.userName});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // width: width * 0.40,
                // height: height * 0.18,
                // width: width * 0.35,
                // height: width * 0.35,
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: GestureDetector(
                  onTap: () {
                    showingToastMessage.customToast(
                        "For better experience please, allow your location",
                        context);
                    Navigator.of(context).pushNamed(
                        JourneyPlaneScreen.routeName,
                        arguments: userName);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    // color: Color.fromRGBO(79, 0, 140, 100),
                    color: Colors.white,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          child: Image.asset("assets/images/plane.png"),
                        ),
                        Text(
                          "Journey Plan",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.of(context).pushNamed(Target.routeName);
              //   },
              //   child: Container(
              //     // width: width * 0.40,
              //     // height: height * 0.18,
              //     // width: width * 0.35,
              //     // height: width * 0.35,
              //     width: 150,
              //     height: 150,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(0)),
              //     ),
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       elevation: 10,
              //       // color: Color.fromRGBO(79, 0, 140, 100),
              //       color: Colors.white,
              //       child: Center(
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Container(
              //               // width: width * 0.30,
              //               // height: height * 0.14,
              //               width: 60,
              //               height: 60,
              //               child: Image.asset("assets/images/target.png"),
              //               // Image.network(
              //               //     "https://cdn-icons-png.flaticon.com/512/702/702980.png"),
              //             ),
              //             Text(
              //               "Target",
              //               style: TextStyle(
              //                   fontSize: 15, fontWeight: FontWeight.bold),
              //             )
              //           ],
              //         ),
              //         //     Text(
              //         //   "Execution",
              //         //   style: TextStyle(
              //         //       fontWeight: FontWeight.bold, color: Colors.white),
              //         // ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.of(context).pushNamed(Knowledge.routeName);
          //       },
          //       child: Container(
          //         // width: width * 0.40,
          //         // height: height * 0.18,
          //         // width: width * 0.35,
          //         // height: width * 0.35,
          //         width: 150,
          //         height: 150,
          //         decoration: const BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(0)),
          //         ),
          //         child: Card(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           elevation: 10,
          //           color: Colors.white,
          //           // color: Color.fromRGBO(79, 0, 140, 100),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 // width: width * 0.25,
          //                 // height: height * 0.1,
          //                 width: 60,
          //                 height: 60,
          //                 child: Image.asset("assets/images/knowledge.png"),
          //                 //  Image.network(
          //                 //     // "https://previews.123rf.com/images/yaroslav2077/yaroslav20772005/yaroslav2077200500007/148712916-book-icon-related-to-education-library-book-store-or-knowledge-symbol.jpg"
          //                 //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ45k8GTfZHqAcNRbHiuvnHnsTseEkyOZ6YDQ&usqp=CAU"),
          //               ),
          //               SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 "Knowledge",
          //                 style: TextStyle(
          //                     fontSize: 15, fontWeight: FontWeight.bold),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     // Container(
          //     //   width: width * 0.40,
          //     //   height: height * 0.18,
          //     //   decoration:
          //     //       BoxDecoration(color: Color.fromRGBO(79, 0, 140, 100)),
          //     //   child: Center(
          //     //       child: Text("KNOWLEDGE",
          //     //           style: TextStyle(
          //     //               fontWeight: FontWeight.bold, color: Colors.white))),
          //     // ),
          //     SizedBox(
          //       width: 20,
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.of(context).pushNamed(Profile.routeName);
          //       },
          //       child: Container(
          //         // width: width * 0.40,
          //         // height: height * 0.18,
          //         // width: width * 0.35,
          //         // height: width * 0.35,
          //         width: 150,
          //         height: 150,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.all(Radius.circular(0)),
          //         ),
          //         child: Card(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           elevation: 10,
          //           // color: Color.fromRGBO(79, 0, 140, 100),
          //           color: Colors.white,
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 // width: width * 0.30,
          //                 // height: height * 0.12,
          //                 width: 70,
          //                 height: 70,
          //                 child: Image.asset("assets/images/person.jpg"),
          //                 // Image.network(
          //                 //   // "https://cdn.pixabay.com/photo/2021/06/07/13/45/user-6318003__340.png"
          //                 //   "https://louisville.edu/enrollmentmanagement/images/person-icon/image",
          //                 // ),
          //               ),
          //               Text(
          //                 "Profile",
          //                 style: TextStyle(
          //                     fontSize: 15, fontWeight: FontWeight.bold),
          //               )
          //             ],
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          SizedBox(
            height: height * 0.2,
          ),
          Logout(),
        ],
      ),
    );
  }
}
