
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class FingerPrint extends StatefulWidget {
  const FingerPrint({Key? key}) : super(key: key);

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometricSensor = [];
  String authorized = "Not autherized";
  bool canCheckBiometricSensor = false;

  Future<void> checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      canCheckBiometricSensor = canCheckBiometric;
    });
  }

  Future<void> getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      availableBiometricSensor = availableBiometric;
    });
  }

  Future<void> authentificate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: "Scanner votre empreinte",
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;
    setState(() {
      authorized = authenticated
          ? "Authentification reussie"
          : "Authentification échouée";
      debugPrint(authorized);
    });
  }
/*
  @override
  void initState() {
    checkBiometric();
    getAvailableBiometric();
    super.initState();
  }
*/
  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold());
  }
}
