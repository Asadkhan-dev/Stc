import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  static const routeName = "/profile";
  const Profile({super.key});

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
