import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import 'company_message.dart';
import 'select_menu.dart';

class DashBoardScreen extends StatefulWidget {
  static const routeName = "dashboard-screen";
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProivder>(context, listen: true).userData;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CompanyMessage(
                  userName: userData!.username,
                  welcomeMessage: userData.welcomeMsg,
                  companyName: userData.companyName),
              SelectMenu(userName: userData.username),
            ],
          ),
        ),
      ),
    );
  }
}
