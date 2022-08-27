// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart';
import '../../components/constants.dart';

class SendMoney extends StatefulWidget {
  final String solde;
  final Map<String, dynamic> data;
  const SendMoney({Key? key, required this.solde, required this.data})
      : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  TextEditingController destinationAddressController = TextEditingController();
  TextEditingController amountToSendController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBarBottomSection(),
          const SizedBox(
            height: 100,
          ),
          mainBody(),
        ],
      ),
    );
  }

  Container appBarBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Fonds total",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 0.9,
                  )),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.solde,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  height: 0.9,
                ),
              ),
              Text(
                ' Fcfa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Expanded mainBody() {
    return Expanded(
      child: Column(
        children: [
          Form(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding * 2),
              child: Column(
                children: [
                  TextFormField(
                    controller: destinationAddressController,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    //onSaved: (email) {},
                    decoration: InputDecoration(
                      hintText: "Adresse du destinataire",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: kSecondaryColor)),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.qr_code),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  TextFormField(
                    controller: amountToSendController,
                    textInputAction: TextInputAction.done,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Montant à transferer",
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.currency_franc),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: kSecondaryColor)),
                    ),
                  ),
                  SizedBox(height: defaultPadding * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Montant restant"),
                      Text(
                          "${double.parse(widget.solde) - double.parse((amountToSendController.text.isNotEmpty) ? amountToSendController.text : "0.0")}"),
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    onPressed: () async {
                      String response = await FlutterBarcodeScanner.scanBarcode(
                          '#ffffff', 'retour', true, ScanMode.QR);
                      print(response);
                    },
                    child: const Icon(
                      Icons.qr_code_scanner_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding * 3),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          print("Tentative d'envoie d'argent");
                          Response response = await post(
                              Uri.parse(
                                  'http://164.92.134.116/api/v1/transactions/'),
                              body: jsonEncode(<String, String>{
                                "user_id": widget.data['user_id'],
                                "send_code": widget.data['send_code'],
                                "receive_code":
                                    destinationAddressController.text,
                                "amount": amountToSendController.text
                              }),
                              headers: <String, String>{
                                "Content-Type": "application/json"
                              });

                          print(
                              "Code de la reponse : [${response.statusCode}]");
                          print("Contenue de la reponse : ${response.body}");

                          if (response.statusCode == 200) {
                            print("Transaction reussie");
                          } else {
                            print("Transaction échouée");
                          }
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Text(
                        "Envoyer",
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
