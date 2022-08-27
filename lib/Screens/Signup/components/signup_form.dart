// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
//import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/constants.dart';
import '../../Login/login_screen.dart';
import '../../Home/home_screen.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  final int pageIndex = 0;

  void startSession(String contact) {
    String isloggedPath = './sessions/.islogged';
    String sessionUserPath = './sessions/$contact.json';

    File isLoggedFile = File(isloggedPath);
    File userSessionFile = File(sessionUserPath);

    String lastUserSession = DateTime.now().toString();
    String sessionData =
        '{\n\t"contact" : "$contact",\n\t"lastSession" : "$lastUserSession"\n}';

    userSessionFile.writeAsStringSync(sessionData);
    isLoggedFile.writeAsStringSync(contact);
  }

  void saveAccount(String data, contact) {
    File userInfo = File("./users/$contact.json");
    userInfo.writeAsStringSync(data);
  }

  Future<String> signUp(String firstname, String lastname, String contact,
      String password) async {
    print("Exécution de la fonction d'inscription ");

    print("Hashage du mot de passe");
    var encodePassword = utf8.encode(password);
    Digest hashpwd = sha256.convert(encodePassword);
    password = hashpwd.toString();

    try {
      print("Tentative d'inscription");
      Response response =
          await post(Uri.parse('http://164.92.134.116/api/v1/signup/'),
              body: jsonEncode(<String, String>{
                "first_name": firstname,
                "last_name": lastname,
                "contact": contact,
                "password": password
              }),
              headers: <String, String>{"Content-Type": "application/json"});

      print("requete envoyé 1");
      print("Code de la reponse : [${response.statusCode}]");
      print("Contenue de la reponse : ${response.body}");

      print("requete envoyé 1");
      if (response.statusCode == 200) {
        print("L'inscription à été éffectué");

        startSession(contact);
        saveAccount(response.body.toString(), contact);

        return response.body.toString();
      } else {
        print("L'inscription à échouée");
        return "fail";
      }
    } catch (e) {
      print("Une ereur est survenue");
      print(e.toString());
      return "fail";
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController lastNameController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController contactController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            decoration: const InputDecoration(
              hintText: "Nom",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: firstNameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Prénoms",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: contactController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Email ou Numéro téléphone",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.numbers),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
            child: TextFormField(
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Confirmation du mot de passe",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.toString() ==
                  confirmPasswordController.text.toString()) {
                if (firstNameController.text.toString().isNotEmpty &&
                    lastNameController.text.toString().isNotEmpty &&
                    contactController.text.toString().isNotEmpty &&
                    passwordController.text.toString().isNotEmpty &&
                    confirmPasswordController.text.toString().isNotEmpty) {
                  signUp(
                          firstNameController.text.toString(),
                          lastNameController.text.toString(),
                          contactController.text.toString(),
                          passwordController.text.toString())
                      .then((value) {
                    if (value == "fail") {
                      print("l'inscription a echouée");
                    } else {
                      Map<String, dynamic> jsonUserData = jsonDecode(value);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyHomePage(
                              data: jsonUserData["data"][0],
                            );
                          },
                        ),
                      );
                    }
                  }).catchError((e) {
                    print("Une erreur est survenue !");
                    print(e);
                  });
                } else {
                  print("Assurez vous de remplir tous les champs");
                }
              } else {
                print("Mot de passe différents");
              }
            },
            child: Text("Inscription".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
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
