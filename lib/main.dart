// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'components/constants.dart';
import './Screens/Home/home_screen.dart';
import './Screens/Welcome/welcome_screen.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'instapay',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
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
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: NextPage(),
    );
  }
}

// ------------- Classe qui designera la page suivante ------------------ //

class NextPage extends StatelessWidget {
  NextPage({Key? key}) : super(key: key);

  // Préparation d'un variable qui contiien contiendra les donnée de l'utilisateur en format Json
  Map<String, dynamic> jsonUserData = jsonDecode("{}");

  /*- checkIfUserLogged verifie si un utilisateur s'est connecté dernièrement
      - Si OUI on charge ses données dans jsonUserData puis on lance la page principale
      - si NON on lance la page de bienvenu invitant l'utilisateur à se connecter ou s'inscrire
  */
  bool checkIfUserIsLogged() {
    // le fichier .isLogged temoigne d'une connection établie par l'utilisateur encore existante
    // Il contient le contact de l'utilisateur connecté
    File file = File('./sessions/.islogged');

    // Tester si le fichier temoin d'une connexion existe
    bool value = file.existsSync();

    if (value) {
      // Si OUI
      print("Un utilisateur est bel et bien connecté");

      //Recuperation du contact de l'utilisateur connecté à partir du fichier de connection
      File loginfile = File('./sessions/.islogged');
      String valueLoginfile = loginfile.readAsStringSync();
      print("Le contact de l'utilisateur connecté est : $valueLoginfile");

      //Se servir du contact de l'utilisateur pour acceder à ses données
      File userdatafile = File('./users/$valueLoginfile.json');
      print("Chargement des données de l'utilisateur à partir de son contact");
      String valueUserdata = userdatafile.readAsStringSync();
      print("Les données de l'utilisateur connecté : $valueUserdata");

      jsonUserData = jsonDecode(valueUserdata);
      print("Check if user is logged is TRUE");
      return true;
    } else {
      // Si NON
      print("Check if user is logged is FALSE");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (checkIfUserIsLogged()) {
      // Si un utilisateur est cinnecté, lancer la page principale
      return MyHomePage(data: jsonUserData);
    } else {
      // Si aucun utilisateur n'est connecté, lancer la page de bienvenue
      return const WelcomeScreen();
    }
  }
}
