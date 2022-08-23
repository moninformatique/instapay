// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../components/constants.dart';
import 'component/qrcode_container.dart';
import '../../components/navbar/navbar.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic>? data;
  const HomePage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        drawer: NavBar(
            //userData: data,
            ),
        appBar: AppBar(
          title: const Text('Bienvenue'),
          backgroundColor: kPrimaryColor,
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrcodeContainer(
                  data: data!['number'] + '@' + data!['cni'],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () async {
                    String res = await FlutterBarcodeScanner.scanBarcode(
                        '#ffffff', 'retour', true, ScanMode.QR);
                    print(res);
                  },
                  child: const Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Colors.white,
                  ),
                )
              ],
            )));
  }
/*
  Future<String> readData() async {
    try {
      File file = File('./conteur.txt');

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 96),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vous etes connecté en tant que " + data!['email']),
                const SizedBox(height: 5),
                Text('Prenoms'),
              ],
            ),
          ),
        ),
      );

      */

}
