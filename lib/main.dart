// ignore_for_file: use_build_context_synchronously

//------------------- Import des packages -----------------------//
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/constants.dart';
import 'Screens/Login/login.dart';
import 'Screens/PinCode/pin_code.dart';

void main() => runApp(const MyApp());

///     MyApp
///     -----
/// Widget racine de l'application

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'instapay',
      // Définition de style globale
      theme: ThemeData(
          primaryColor: kSimpleTextColor,
          scaffoldBackgroundColor: kBackgroundBodyColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide.none),
          )),
      home: const LoadPage(),
    );
  }
}

///     LoadPage
///     --------
///   Ce Widget a pour rôle de déterminer la page qui doit être charger deh le démarrage de l'application
///   entre la page de connexion (LoginScreen) s'il n'existe aucun utilisateur connecté et
///   la page d'authentification par code PIN (PinCodeAuth) s'il y a déjà un utilisateur connecté.///

class LoadPage extends StatefulWidget {
  const LoadPage({Key? key}) : super(key: key);

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    checkSession();
  }

  // Fonction de verificatio de session existante
  void checkSession() async {
    // Ici nous alons obtenir les informations de l'utlisateur sauvegardées lors de l'inscription
    // Il sont enregistré en chaine de caractère == les convertir en format json pour utiliser les données.
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userEmail = pref.getString("user");
    String? userPinCode = pref.getString("pin");

    if (userEmail != null && userPinCode != null) {
      // Il existe de données utilisateur == un utilisateur s'est déjà connecté

      debugPrint("Utilisateur connecté [$userEmail] ");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PinCodeAuth(userContact: userEmail.toString())));
    } else {
      debugPrint("[Aucun utilisateur connecté] ");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
