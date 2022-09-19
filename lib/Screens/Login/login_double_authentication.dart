// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../PinCode/create_pin_code.dart';
import '../../../components/constants.dart';

///
///     DoubleAuthentication
///     ---------
/// Dans ce Widget est contruit le formulaire de seconde authentification
///

class DoubleAuthentication extends StatefulWidget {
  final String userToken;
  final String userEmail;
  const DoubleAuthentication(
      {Key? key, required this.userToken, required this.userEmail})
      : super(key: key);

  @override
  State<DoubleAuthentication> createState() => _DoubleAuthenticationState();
}

class _DoubleAuthenticationState extends State<DoubleAuthentication> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool submitEnabled = false;
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(mediumPadding),
          child: Column(children: [
            const SizedBox(
              height: largePadding * 2,
            ),
            // Titre
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Double authentification',
                    style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: kBoldTextColor)),
                  ),
                ),
              ],
            ),

            // Message
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Vous avez réçu un code à l'addresse mail@instapay.com.",
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
                  height: largePadding * 3,
                ),
                // Fonrmulaire de double authentification
                doubleAuthentificationForm(),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget doubleAuthentificationForm() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Champ du code d'authentification
            TextFormField(
              onChanged: (value) {
                setState(() {
                  submitEnabled = (value.length == 8) ? true : false;
                });
              },
              controller: codeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.numbers),
                hintText: "Code d'authentification",
              ),
              validator: (authCode) {
                return authCode != null && authCode.length != 8
                    ? "Doit contenir 8 caractères numérique"
                    : null;
              },
            ),
            const SizedBox(height: bigMediumPadding),

            loading
                ? const CircularProgressIndicator(
                    color: kPrimaryColor,
                    strokeWidth: 5,
                  )
                :
                // Boutton de connexion
                ElevatedButton(
                    style: ElevatedButton.styleFrom(onSurface: kPrimaryColor),
                    onPressed: (submitEnabled)
                        ? () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              setState(() {
                                loading = true;
                              });
                              debugPrint("Formulaire valide ... ");

                              confirmCodeForDoubleAuthentication();
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

  // validation de la double authentification
  void confirmCodeForDoubleAuthentication() async {
    debugPrint(
        "Exécution de la fonction de validation de code de la double authentification ... ");

    try {
      debugPrint("[..] Tentative de seconde authentification");
      debugPrint("  --> Envoie de la requete de seconde authentification");
      Response response =
          await post(Uri.parse('${api}login/second_authentication/'),
              body: jsonEncode(<String, dynamic>{
                "second_authentication_code": codeController.text,
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.userToken}"
          });

      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        goToCreatePinCodeScreen(widget.userEmail);
      } else {
        showInformation(context, false, "Authentification échouée");
      }
    } catch (e) {
      showInformation(context, false, "Vérifiez votre connexion internet");
      setState(() {
        loading = false;
      });
    }
  }

  // Fonction de chargement de la page de creation de code PIN
  void goToCreatePinCodeScreen(String userEmail) {
    debugPrint(" Chargement de la page d'accueil");
    codeController.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePinCode(userEmail: userEmail)),
        (route) => false);
  }

  showInformation(BuildContext context, bool isSuccess, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      //behavior: SnackBarBehavior.floating,
      backgroundColor: isSuccess ? successColor : errorColor,
      //elevation: 3,
    ));
  }
}
