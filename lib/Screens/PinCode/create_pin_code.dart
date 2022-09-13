// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../Login/login.dart';
import 'components/numeric_pad.dart';
import 'components/top_pincode_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home_screen.dart';
import 'components/pin_widget.dart';
import '../../components/constants.dart';

///
///     CreatePinCode
///     -----------
/// Cette page consiste à Permettre à l'utilisateur qui vient de se connecter ou de s'inscrire
/// de créer un code PIN pour acceder à la page d'accueil de l'application
///

class CreatePinCode extends StatefulWidget {
  final String userEmail;
  const CreatePinCode({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<CreatePinCode> createState() => _CreatePinCodeState();
}

class _CreatePinCodeState extends State<CreatePinCode> {
  String userImage = "assets/logos/5-rb.png";
  String userMessage = "Enregistrez votre code PIN";

  bool codepinDisMatch = false;
  PinController pincodeController = PinController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),

          // Partie supérieure de la page
          TopPincodeScreen(
              userEmail: widget.userEmail,
              userImage: userImage,
              userMessage: userMessage),

          // Points indiquant une entrée du code PIN
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Les points de marquage d'entrer ou pas d'un chiffre du code PIN
                PinWidget(
                    pinLegth: 5,
                    controller: pincodeController,
                    onCompleted: (code) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavePinCode(
                                userEmail: widget.userEmail, pincode: code),
                          ));
                    }),
              ],
            ),
          ),

          // Espace entre les Widgets d'en haut et celui du clavier numerique en bas
          const Spacer(),

          // Clavier numérique
          NumericPad(pincodeController: pincodeController),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  // Widget de construction des bouttons du clavier numérique
  MaterialButton buildMaterialButton(int number) {
    return MaterialButton(
      onPressed: () {
        pincodeController.addInput('$number');
      },
      textColor: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(
          '$number',
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}

///
///       SavePinCode
///       -----------
/// Cette page permet de Confirmer et sauvegarder le code pin
///

class SavePinCode extends StatefulWidget {
  final String pincode;
  final String userEmail;
  const SavePinCode({
    Key? key,
    required this.pincode,
    required this.userEmail,
  }) : super(key: key);

  @override
  State<SavePinCode> createState() => _SavePinCodeState();
}

class _SavePinCodeState extends State<SavePinCode> {
  String userImage = "assets/logos/5-rb.png";
  String userMessage = "Confirmez votre code PIN";

  bool codepinDisMatch = false;
  bool dataNotFound = false;
  PinController pincodeController = PinController();

  // Fonction de chargement de la page d'acceuil après enregistrement du code pin
  goToHomePage(String code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // Hasher le code pin
    var encodePin = utf8.encode(code);
    String pingHash = sha256.convert(encodePin).toString();

    // Stocker dans la memoire de l'appareil
    await pref.setString("pin", pingHash);
    await pref.setString("user", widget.userEmail);
    debugPrint("Code Pin : $code / $pingHash");

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userEmail: widget.userEmail),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),

          // Partie supérieur de la page
          TopPincodeScreen(
              userImage: userImage,
              userMessage: userMessage,
              userEmail: widget.userEmail),

          // Boutton d'entre de code pin
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Les points de marquage d'entrer ou pas d'un chiffre du code PIN
                PinWidget(
                    pinLegth: 5,
                    controller: pincodeController,
                    onCompleted: (codePin) {
                      if (codePin == widget.pincode) {
                        goToHomePage(codePin);
                      } else {
                        // Animation mauvais code PIN
                        pincodeController.notifyWrongInput();
                        codepinDisMatch = true;
                        setState(() {});
                      }
                    }),
              ],
            ),
          ),

          // Bouton de code PIN oublié en cas d'une entrée incorrecte
          (codepinDisMatch)
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreatePinCode(
                                  userEmail: widget.userEmail,
                                )));
                  },
                  child: const Text("Recommencer",
                      style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                )
              : Container(),

          (dataNotFound)
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text("Se connecter",
                      style: TextStyle(color: kPrimaryColor, fontSize: 12)),
                )
              : Container(),

          // Espace entre les Widgets d'en haut et celui du clavier numerique en bas
          const Spacer(),

          // Clavier numérique
          NumericPad(pincodeController: pincodeController),

          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  // Widget de construction des bouttons du clavier numérique

  MaterialButton buildMaterialButton(int number) {
    return MaterialButton(
      onPressed: () {
        pincodeController.addInput('$number');
      },
      textColor: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Text(
          '$number',
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
