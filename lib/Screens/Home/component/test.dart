// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../components/constants.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
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
        ),
        const Spacer(),
      ],
    );
  }
}
