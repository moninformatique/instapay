// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import '../../../../components/constants.dart';

class ProtectionCodeScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> tokens;
  const ProtectionCodeScreen(
      {Key? key, required this.data, required this.tokens})
      : super(key: key);

  @override
  State<ProtectionCodeScreen> createState() => _ProtectionCodeScreenState();
}

class _ProtectionCodeScreenState extends State<ProtectionCodeScreen> {
  final formKey = GlobalKey<FormState>();
  bool isSubmitEnable = false;
  bool loading = false;
  bool obscureText = true;
  TextEditingController codeController = TextEditingController();
  String mysolde = "0";
  String code = "";

  @override
  void initState() {
    super.initState();

    codeController.addListener(() {
      var code = codeController.text;

      setState(() {
        isSubmitEnable = (code.isNotEmpty && code.length == 4) ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: defaultPadding,
              ),

              // Message
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Entrez votre code de protection pour valider votre opération !",
                      style: TextStyle(color: Colors.grey.shade600),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),

              // Formulaire de double authetification
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: largePadding,
                  ),
                  // Fonrmulaire de double authentification
                  protectionCodeForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Protection du compte",
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget protectionCodeForm() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Champ du code de protection du compte

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: largePadding),
              child: TextFormField(
                onChanged: (value) {},
                controller: codeController,
                keyboardType: TextInputType.number,
                obscureText: obscureText,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.numbers),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility),
                  ),
                  hintText: "Code",
                ),
                validator: (authCode) {
                  return (authCode != null && authCode.length != 4)
                      ? "Contient 4 chiffres"
                      : null;
                },
              ),
            ),

            const SizedBox(height: largePadding * 3),
            loading
                ? const CircularProgressIndicator(
                    color: kPrimaryColor,
                    strokeWidth: 5,
                  )
                :
                // Boutton de connexion
                ElevatedButton(
                    style: ElevatedButton.styleFrom(onSurface: kPrimaryColor),
                    onPressed: (isSubmitEnable)
                        ? () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              debugPrint("Formulaire valide ... ");

                              sendMoneyToSomeone();
                            }
                          }
                        : null,
                    child: Text("Confirmer".toUpperCase())),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade500,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Retour".toUpperCase())),
          ],
        ),
      ),
    );
  }

  sendMoneyToSomeone() async {
    try {
      Response response = await post(Uri.parse("${api}users/transactions/"),
          headers: {
            "Authorization": "Bearer ${widget.tokens['access']}",
            "Content-type": "application/json"
          },
          body: jsonEncode({
            "receiver": widget.data['receiver'],
            "amount": widget.data['amount'],
            "date": widget.data['date'],
            "account_protection_code": codeController.text
          }));

      if (response.statusCode == 200) {
        debugPrint("paiement éffectué");
        debugPrint('le contenu de la reponse : ${response.body}');
        Navigator.pop(context);
        openDialog("Transaction éffectué", true);
      } else {
        debugPrint("echec du paiement : ${response.body}");
        openDialog("Transaction échouée", false);
      }
    } catch (e) {
      debugPrint("erreur : ${e.toString()}");
    }
  }

  Future openDialog(String message, bool status) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Icon(
                    status ? Icons.check_circle : Icons.error,
                    color: status ? successColor : errorColor,
                    size: 100,
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    /*
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ProtectionCodeScreen()));*/
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: kPrimaryColor),
                  ))
            ],
          )));
}
