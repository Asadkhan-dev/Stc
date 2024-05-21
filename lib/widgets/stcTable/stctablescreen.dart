import 'package:flutter/material.dart';

import 'stc_table.dart';

class STCTableScreen extends StatelessWidget {
  static const routeName = "stc-tableScreen";
  const STCTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: STCTable(),
    );
  }
}
