import 'package:flutter/material.dart';

import 'check_in.dart';

class CheckInScreen extends StatelessWidget {
  static const routeName = "check-in-screen";
  const CheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CheckIn(),
    );
  }
}
