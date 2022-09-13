// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'create_pin_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/numeric_pad.dart';
import 'components/pin_widget.dart';
import 'components/top_pincode_screen.dart';
import '../Home/home_screen.dart';
import '../Login/login.dart';

///     PinCodeAuth
///     -----------
/// Cette page a pour but de s'assurer que l'individu qui tente d'acceder à l'application est
/// bien celui qui est connecté actuellement. Car celui-ci a été invité a enregistrer un cde PIN qui
/// le permettra d'acceder à la page d'accueil de l'application.

class PinCodeAuth extends StatefulWidget {
  final String userContact;
  const PinCodeAuth({Key? key, required this.userContact}) : super(key: key);

  @override
  State<PinCodeAuth> createState() => _PinCodeAuthState();
}

class _PinCodeAuthState extends State<PinCodeAuth> {
  bool forgetPin = false;
  PinController pincodeController = PinController();
  List<int> firstRow = [1, 2, 3], secondRow = [4, 5, 6], thirdRow = [7, 8, 9];

  // Fonction de vérification de l'exactitude du code PIN entré
  verifyCodePin(String code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //hasher le code pin pour le comparer avec celui qui a été déjà enregistré
    var encodePin = utf8.encode(code);
    String pinEntred = sha256.convert(encodePin).toString();
    String? pinSaved = pref.getString("pin");

    if (pinSaved != null) {
      // Un code PIN a été enregistré
      debugPrint(" PIN  Enregistré : $pinSaved \n PIN Entré : $pinEntred");
      if (pinSaved == pinEntred) {
        // Le code PIN entré est correct
        debugPrint("Le code PIN est correcte");
        String? userEmail = pref.getString("user");

        if (userEmail != null) {
          //Map<String, dynamic> userData = jsonDecode(savedData);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userEmail: userEmail)));
        }
      } else {
        // le code PIN entré est incorret
        debugPrint("Le code PIN est incorrecte");
        pincodeController.notifyWrongInput();
        forgetPin = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text("Mauvais code PIN")],
        )));
      }
    } else {
      // Aucun code PIN n'a été enregistré, conduire l'utilisateur à la page de connexion
      debugPrint("Aucun code PIN n'as été enregistré");
      await pref.clear();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePinCode(
              userEmail: widget.userContact,
            ),
          ));
    }
    setState(() {});
  }

  // Fonction de décconexio de l'utilisateur connecté
  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    debugPrint("Déconnexon de l'utilisateur ...");

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),

          // Bouton de déconnexion
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text(
                    "Déconnexion",
                    style: TextStyle(color: Colors.red, fontSize: 10),
                  )),
            ],
          ),

          // Partie supérieur de la page
          TopPincodeScreen(
            userEmail: widget.userContact,
            userImage: "assets/logos/5-rb.png",
            userMessage: "Bon retour",
          ),

          // Les points de marquage d'entrer ou pas d'un chiffre du code PIN
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PinWidget(
                    pinLegth: 5,
                    controller: pincodeController,
                    onCompleted: (pincode) {
                      verifyCodePin(pincode);
                    }),
              ],
            ),
          ),

          // Bouton de code PIN oublié en cas d'une entrée incorrecte
          (forgetPin)
              ? TextButton(
                  onPressed: () {},
                  child: const Text("Code Pin oublié ?",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                )
              : Container(),

          // Espace entre les Widgets d'en haut et celui du clavier numerique en bas
          const Spacer(),

          // Clavier numérique
          NumericPad(
            pincodeController: pincodeController,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
