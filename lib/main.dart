// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import './Screens/Home/home_screen.dart';
import './Screens/Welcome/welcome_screen.dart';
import 'components/constants.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class NextPage extends StatelessWidget {
  NextPage({Key? key}) : super(key: key);

  Map<String, dynamic> jsonUserData = jsonDecode("{}");

  bool checkIfUserIsLogged() {
    final usersDirectory = Directory("./users");
    final sessionsDirectory = Directory("./sessions");

    if (!usersDirectory.existsSync()) {
      usersDirectory.createSync(recursive: true);
    }
    if (!sessionsDirectory.existsSync()) {
      sessionsDirectory.createSync(recursive: true);
    }

    File file = File('./sessions/.islogged');
    // Tester si le fichier temoin d'une connexion existe
    print(
        "Teste de l'existence  du fichier temoin d'une connexion à l'application ");
    bool value = file.existsSync();

    if (value) {
      print("Le fichier temoin d'une connexion existe belle et bien");
      // si oui, lire le contenu du fichier qui est son contact

      print("Extration du fichier temoin le contact de l'utilisateur connecté");
      File loginfile = File('./sessions/.islogged');
      String valueLoginfile = loginfile.readAsStringSync();
      print("Le contact de l'utilisateur connecté est : $valueLoginfile");

      //se servir de son contact pour acceder aus données de l'utilisateur
      File userdatafile = File('./users/$valueLoginfile.json');
      print("Chargement des données de l'utilisateur à partir de son contact");
      String valueUserdata = userdatafile.readAsStringSync();
      print("Les données de l'utilisateur connecté : $valueUserdata");

      jsonUserData = jsonDecode(valueUserdata);
      print("Check if user is logged is TRUE");
      return true;
    } else {
      print("Check if user is logged is FALSE");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //bool varTest = false;
    if (checkIfUserIsLogged()) {
      print("*************TRUE***************");
      print(jsonUserData["first_name"]);
      return MyHomePage(data: jsonUserData);
    } else {
      print("****************FALSE***********");
      return const WelcomeScreen();
    }
  }
}
