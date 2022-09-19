import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 5), () {
      debugPrint("Executed after 5 seconds");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    });
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
