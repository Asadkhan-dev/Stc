import 'package:flutter/material.dart';

class CompanyMessage extends StatelessWidget {
  final String userName;
  final String welcomeMessage;
  final String companyName;

  const CompanyMessage(
      {super.key,
      required this.userName,
      required this.welcomeMessage,
      required this.companyName});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              // height: height * 0.07,
              height: 50,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome $userName",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  Container()
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: height * 0.12,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Center(child: Text(welcomeMessage)),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
