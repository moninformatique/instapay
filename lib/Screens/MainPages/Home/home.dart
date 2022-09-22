// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Payment/SendMoney/send_money.dart';

import '../../../components/constants.dart';
import '../Transactions/transactions_summary.dart';
import 'qrcode_container.dart';

class Home extends StatefulWidget {
  final String token;
  final String userEmail;
  final double balance;

  const Home({
    Key? key,
    required this.token,
    required this.userEmail,
    required this.balance,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isFront = true;
  Map<String, dynamic> tokens = {};

  @override
  void initState() {
    setState(() {
      getTokens();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight / 2,
          ),
          (isFront) ? card() : cardBack(),
          const SizedBox(
            height: bigMediumPadding,
          ),
          TransactionsSummary(
            token: widget.token,
          ),
        ],
      ),
    ));
  }

  Widget card() {
    return Container(
      padding: const EdgeInsets.all(8),
      //margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        // Ce widget Column est contitué de deux autres widgets Row, qui divise la carte en deux partie Supérieure et Inférieure
        // 1er Row : Partie supérieure qui contient un logo et les bouttons d'action
        // 2e Row : Partie inférieure en inférieur qui contient le solde du compte
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partie Supérieure
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo sur la carte
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: kBackgroundBodyColor,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: Image.asset(
                    "assets/logos/4-rb.png",
                  ),
                ),
              ),

              // Bouttons d'actions
              Row(
                children: [
                  // Pour se recharger
                  IconButton(
                    tooltip: "Se recharger",
                    onPressed: () {
                      debugPrint("Se recharger");
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                  ),

                  // Afficher son code QR pour recevoir de l'argent
                  IconButton(
                    tooltip: "Voir mon QR code",
                    onPressed: () {
                      debugPrint("Voir mon QR code");
                      setState(() {
                        isFront = false;
                      });
                    },
                    icon: const Icon(
                      Icons.qr_code_2,
                      color: Colors.white,
                    ),
                  ),

                  // Scanner un code QR pour envoyer de l'argent
                  IconButton(
                    tooltip: "Scanner un QR code",
                    onPressed: () async {
                      debugPrint("Scanner un QR code");
                      String response = await FlutterBarcodeScanner.scanBarcode(
                          '#ffffff', 'Quitter', true, ScanMode.QR);
                      debugPrint(response);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SendMoney(
                                    balance: widget.balance,
                                    tokens: tokens,
                                    receiptEmail: response,
                                  )));
                    },
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Partie Inférieur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Affichage du solde
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label solde
                  const Text(
                    "Solde",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  // Montant solde
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Montant
                      Text(
                        "${widget.balance}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        width: 5,
                      ),
                      // Devise
                      const Text("Fcfa",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardBack() {
    return Container(
      padding: const EdgeInsets.all(8),
      //margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Ce widget Column est contitué de deux autres widgets Row, qui divise la carte en deux partie Supérieure et Inférieure
        // 1er Row : Partie supérieure qui contient un logo et les bouttons d'action
        // 2e Row : Partie inférieure en inférieur qui contient le solde du compte
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partie gauche
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo sur la carte
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: kBackgroundBodyColor,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: Image.asset(
                    "assets/logos/4-rb.png",
                  ),
                ),
              ),
            ],
          ),

          // Partie centrée
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: Colors.white,
              border: Border.all(color: kPrimaryColor, width: 1.0),
            ),
            child: QrcodeContainer(
              data: widget.userEmail,
            ),
          ),

          // Partie droite
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Pour se recharger
              IconButton(
                tooltip: "Se recharger",
                onPressed: () {
                  debugPrint("Se recharger : Afficher l'avant de la carte");
                  setState(() {
                    isFront = true;
                  });
                },
                icon: const Icon(
                  Icons.cached,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getTokens() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? data = pref.getString("token");
    debugPrint("************************  GET TOKEN *******************");
    if (data != null) {
      setState(() {
        debugPrint("********************setstate***********************");
        tokens = jsonDecode(data);
        debugPrint("$tokens");
      });
    }
    debugPrint("*******************************************");
  }
}
