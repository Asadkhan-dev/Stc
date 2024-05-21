import 'package:flutter/material.dart';

class Target extends StatelessWidget {
  static const routeName = "/target";
  const Target({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios)),
            SizedBox(
              height: height * 0.4,
            ),
            Center(
              child: Text("Data will be available in the next version"),
            ),
          ],
        ),
      ),
    );
  }
}
