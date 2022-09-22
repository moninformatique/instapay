// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/constants.dart';

import '../Home/home_screen.dart';

class Loading extends StatefulWidget {
  final String userEmail;
  const Loading({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      debugPrint("Executed after 5 seconds");

      goToHomeScreen();
    });
  }

  goToHomeScreen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? tokens = pref.getString("token");

    if (tokens != null) {
      var token = jsonDecode(tokens);
      debugPrint(token["access"]);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    token: token["access"],
                  )),
          (route) => false);
    } else {
      await pref.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: width / 3, right: width / 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logos/4-rb.png",
              height: 120,
              width: 120,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(),
              child: LinearProgressIndicator(
                backgroundColor: kPrimaryLightColor,
                color: kPrimaryColor,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
