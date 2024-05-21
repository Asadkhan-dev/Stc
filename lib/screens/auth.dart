import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/authprovider.dart';
import '../widgets/dashboard/dashboardScreen.dart';
import '../widgets/lodingpage.dart';
import 'toastmessage.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "auth-route";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var userName = "";
  var password = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _submitAuthForm() async {
    _formKey.currentState!.save();
    if (userName.isEmpty) {
      showingToastMessage.ErrorToast("Please, enter your user name", context);

      return;
    } else if (password.isEmpty) {
      showingToastMessage.ErrorToast("Please, enter your password", context);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProivder>(context, listen: false)
          .login(userName, password)
          .then((value) {
        if (value) {
          Navigator.of(context).pushReplacementNamed(DashBoardScreen.routeName);
        } else {
          showingToastMessage.ErrorToast("Invalid credentials", context);
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      showingToastMessage.ErrorToast(error.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _isLoading
        ? MyLoadingSpinner()
        : Scaffold(
            body: Container(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      color: const Color.fromRGBO(79, 0, 140, 1),
                      width: width,
                      height: height * 0.43,
                    ),
                  ),
                  Positioned(
                    top: height * 0.1,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: Image.asset("assets/images/stclogo.jpeg"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Login to C Store STC",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: height * 0.32,
                    child: Form(
                      key: _formKey,
                      child: Container(
                        // width: width * 0.85,
                        width: width > 481 ? 400 : width * 0.85,
                        height: height * 0.55,
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 40),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Username",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: height * 0.07,
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromARGB(
                                                  255, 226, 226, 226),
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, left: 10),
                                              hintText: "username",
                                              border: InputBorder.none),
                                          initialValue: userName,
                                          onSaved: (newValue) {
                                            userName = newValue!;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Text(
                                        "Password",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: height * 0.07,
                                        child: TextFormField(
                                          obscureText: true,
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromARGB(
                                                  255, 226, 226, 226),
                                              contentPadding: EdgeInsets.only(
                                                  top: 0, left: 10),
                                              hintText: "password",
                                              border: InputBorder.none),
                                          initialValue: password,
                                          onSaved: (newValue) {
                                            password = newValue!;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    79, 0, 140, 1),
                                            minimumSize: Size(width, 45),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0))),
                                        onPressed: () {
                                          _submitAuthForm();
                                        },
                                        child: const Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text("Version 1.4"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
