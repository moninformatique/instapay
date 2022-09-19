
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool hasInternet = false;
  //late StreamSubscription subscription;
  String mysolde = "0";
  String sendCode = "";
  String receiveCode = "";

  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      final internet = status == InternetConnectionStatus.connected;

      setState(() {
        hasInternet = internet;

        if (hasInternet) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    //subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_bad,
            color: Colors.grey.shade400,
            size: 150,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "Pas d'accès à internet",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    hasInternet =
                        await InternetConnectionChecker().hasConnection;

                    if (hasInternet) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Reéssayer")),
            ],
          ),
        ],
      ),
    );
  }
}





