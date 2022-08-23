// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable, unnecessary_null_comparison, unused_import, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/constants.dart';
import '../../Signup/signup_screen.dart';
import '../../Home/home_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  Future<void> getData() async {
    //Méthode de requête à l'api
    Uri url = Uri.parse("http://devinstapay.pythonanywhere.com/api/v1/login/");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      print("ok");
    } else {
      print(response.statusCode);
    }
  }

  Future<String?> signIn(String path) {
    print("1 - SIGN IN WITH ($path)");
    File file = File(path);
    //bool check = file.exists() as bool;
    final contents = file.readAsString();
    return contents;
  }

  Future<String?> readuserFile(String path) async {
    print("READ USER FILE");
    print("Chargement, du compte");
    print(path);

    try {
      File file = File(path);

      // Read the file
      final contents = await file.readAsString();
      print("(read user file) Contenu du compte est : ");
      String texte = contents.toString();
      print(texte);
      return contents;
    } catch (e) {
      print("Error");
      print(e.toString());
      return null;
    }
  }

  Future<File?> startSession(String user) async {
    String isloggedPath = './sessions/.islogged';
    String sessionUserPath = './sessions/$user.json';
    DateTime today = DateTime.now();
    String lastSession = today.toString();
    String sessionData =
        '{\n\t"user" : "$user",\n\t"lastSession" : "$lastSession"\n}';

    File sessionUser = File(sessionUserPath);
    sessionUser.writeAsString(sessionData);

    try {
      File login = File(isloggedPath);

      return login.writeAsString(user);
    } catch (e) {
      print("Error");
      print(e.toString());
      return null;
    }
  }

  String? checkIfUserExist(String path) {
    print("CHECK IF USER EXIST");
    readuserFile(path).then((value) {
      print("(check if user exist) Contenu du compte est : ");
      print(value);
      if (value != null) {
        print("on retourne le contenu du compte ");
        return value;
      } else {
        return null;
      }
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController contactController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: contactController,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            //onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Numero de téléphone",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.contact_phone),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                signIn('./users/${contactController.text}.json'.toString())
                    .then((value) {
                  print("2 - RECEPTION DES DONNEES ");
                  print(value);
                  print("3 - CONVERSION DES DONNEES EN OBJET JSON");
                  Map<String, dynamic> jsonUserData = jsonDecode(value!);
                  print("4 - COMPARAISON DES MOTS DE PASSE ");
                  print(
                      "Mot de passe enregistré : " + jsonUserData['password']);

                  String password = passwordController.text.toString();
                  var encodePassword = utf8.encode(password);
                  Digest hashpwd = sha256.convert(encodePassword);
                  String passwordHashed = hashpwd.toString();
                  print("Mot de passe renseigné : $password");
                  print("Hash du mot de passe renseigné" +
                      passwordHashed.toString() +
                      "****");
                  print("Hash du mot de passe inscrit : " +
                      jsonUserData['password']);
                  if (jsonUserData['password'].toString() ==
                      passwordHashed.toString()) {
                    print("5 - MOT DE PASSE IDENTIQUES ");
                    getData();
                    startSession(contactController.text.toString());
                    print("6 - CONNEXION REUSSIE");
                    print("7 - OUVERTURE DE LA PAGE D'ACCUEIL");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MyHomePage(
                            data: jsonUserData,
                          );
                        },
                      ),
                    );
                  } else {
                    print("5 - MOT DE PASSE DIFFÉRENTS");
                    print("6 - CONNEXION ECHOUEE");
                  }
                }).catchError((onError) {
                  print("ERREUR SURVENUE !!!");
                  print(onError);
                });
              },
              child: Text(
                "Connexion".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextButton(
            onPressed: () {
              print("Chargement du formulaire de recupération de mot de passe");
            },
            child: Text(
              "Mot de passe oublié ?",
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
