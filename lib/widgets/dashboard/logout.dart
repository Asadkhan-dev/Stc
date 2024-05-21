import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/authprovider.dart';
import '../../screens/auth.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: width > 481 ? Size(400, 45) : Size(width, 45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: () async {
          Provider.of<AuthProivder>(context, listen: false).logOut();
          Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
        },
        child: const Text("Logout"),
      ),
    );
  }
}
