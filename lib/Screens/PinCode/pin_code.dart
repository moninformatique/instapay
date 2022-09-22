// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../components/constants.dart';
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
  final String userEmail;
  const PinCodeAuth({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<PinCodeAuth> createState() => _PinCodeAuthState();
}

class _PinCodeAuthState extends State<PinCodeAuth> {
  bool forgetPin = false;
  PinController pincodeController = PinController();

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
          for (var i = 0; i < 5; i++) {
            pincodeController.delete();
          }
          String? tokens = pref.getString("token");
          if (tokens != null) {
            var token = jsonDecode(tokens);
            debugPrint(token["access"]);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          token: token["access"],
                        )),
                (route) => false);
          } else {
            logout();
          }
        } else {
          logout();
        }
      } else {
        // le code PIN entré est incorret
        debugPrint("Le code PIN est incorrecte");
        pincodeController.notifyWrongInput();
        forgetPin = true;
      }
    } else {
      // Aucun code PIN n'a été enregistré, conduire l'utilisateur à la page de connexion
      debugPrint("Aucun code PIN n'as été enregistré");

      logout();
    }
    setState(() {});
  }

  // Fonction de décconexio de l'utilisateur connecté
  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? tokenData = pref.getString("token");
    debugPrint(tokenData);
    var jsonTokenData = jsonDecode(tokenData!);

    debugPrint("Déconnexon de l'utilisateur ...");

    try {
      Response response =
          await post(Uri.parse('${api}login/second_authentication/'),
              body: jsonEncode(<String, dynamic>{
                "refresh": jsonTokenData["refresh"],
              }),
              headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${jsonTokenData["access"]}"
          });

      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");
      if (response.statusCode == 200) {
        await pref.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    } catch (e) {
      showInformation(context, false, "Vérifiez votre connexion internet");
    }
  }

  // Affiche des informations en rapport avec les resultats des requetes à l'utilisateur
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
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  )),
            ],
          ),

          // Partie supérieur de la page
          TopPincodeScreen(
            userEmail: widget.userEmail,
            userImage: "assets/logos/4-rb.png",
            userMessage: "Bon retour",
          ),

          // Les points de marquage d'entrer ou pas d'un chiffre du code PIN
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PinWidget(
                    pinLength: 5,
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
                      style: TextStyle(color: kWeightBoldColor, fontSize: 12)),
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
