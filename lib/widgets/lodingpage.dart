import 'package:flutter/material.dart';

class MyLoadingSpinner extends StatefulWidget {
  static const routeName = "spinner-route";
  @override
  _MyLoadingSpinnerState createState() => _MyLoadingSpinnerState();
}

class _MyLoadingSpinnerState extends State<MyLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300000),
      vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
              turns: Tween(begin: 0.0, end: 150.0).animate(_controller),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Color.fromRGBO(79, 0, 141, 1),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/stclogo.jpeg"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
