import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../components/constants.dart';

class SendMoney extends StatefulWidget {
  final String userID;
  final String solde;
  final String sendCode;
  final String receiveCode;
  const SendMoney(
      {Key? key,
      required this.userID,
      required this.solde,
      required this.sendCode,
      required this.receiveCode})
      : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  TextEditingController destinationAddressController = TextEditingController();
  TextEditingController amountToSendController = TextEditingController();
  String mysolde = "0";

  void accountRequest(String userID) async {
    Map<String, dynamic> account = jsonDecode("{}");

    debugPrint("Tentative de recupération des infos solde");
    Response response = await get(Uri.parse('${api}users/$userID/accounts/'));

    debugPrint("Code de la reponse : [${response.statusCode}]");
    debugPrint("Contenue de la reponse : ${response.body}");

    if (response.statusCode == 200) {
      String userAccountData = response.body.toString();
      Map<String, dynamic> tmp = jsonDecode(userAccountData);

      account = tmp['account_owner'][0];
      debugPrint("Retour du solde du client");
      mysolde = account['amount'].toString();
    } else {
      debugPrint("La requete e échouée");
      mysolde = "0";
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //accountRequest(widget.userID);
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBarBottomSection(),
          const SizedBox(
            height: 20,
          ),
          mainBody(),
        ],
      ),
    );
  }

  Container appBarBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: kWeightBoldColor,
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(color: kPrimaryColor.withOpacity(0.1), width: 2),
              boxShadow: [
                BoxShadow(
                  color: kSimpleTextColor.withOpacity(0.4),
                  offset: const Offset(0, 8),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vous disposez de',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.solde,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    ),
                    const Text(
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
              ],
            ),
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
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
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
                          borderSide: const BorderSide(color: kPrimaryColor)),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.qr_code),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TextFormField(
                    controller: amountToSendController,
                    textInputAction: TextInputAction.done,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Montant à transferer",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.currency_franc),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: kPrimaryColor)),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant restant"),
                      Text(
                          "${double.parse(widget.solde) - double.parse((amountToSendController.text.isNotEmpty) ? amountToSendController.text : "0.0")}"),
                    ],
                  ),*/
                  const SizedBox(height: defaultPadding * 2),
                  FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    onPressed: () async {
                      String response = await FlutterBarcodeScanner.scanBarcode(
                          '#ffffff', 'retour', true, ScanMode.QR);
                      debugPrint(
                          "==========================================================================================");
                      debugPrint(response);
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
                        if (int.parse(widget.solde) >
                            int.parse((amountToSendController.text.isNotEmpty)
                                ? amountToSendController.text
                                : "0")) {
                          if (widget.receiveCode !=
                              destinationAddressController.text) {
                            try {
                              debugPrint("Tentative d'envoie d'argent");
                              Response response = await post(
                                  Uri.parse('${api}transactions/'),
                                  body: jsonEncode(<String, String>{
                                    "user_id": widget.userID,
                                    "send_code": widget.sendCode,
                                    "receive_code":
                                        destinationAddressController.text,
                                    "amount": amountToSendController.text
                                  }),
                                  headers: <String, String>{
                                    "Content-Type": "application/json"
                                  });

                              debugPrint(
                                  "Code de la reponse : [${response.statusCode}]");
                              debugPrint(
                                  "Contenue de la reponse : ${response.body}");

                              if (response.statusCode == 200) {
                                debugPrint("Transaction reussie");
                              } else {
                                debugPrint("Transaction échouée");
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Text("Transaction inutile")],
                            )));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Votre solde est insuffisant")
                            ],
                          )));
                        }
                      },
                      child: const Text(
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
