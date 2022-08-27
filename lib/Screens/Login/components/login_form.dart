// ignore_for_file: avoid_print

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

//import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/constants.dart';
import '../../Signup/signup_screen.dart';
import '../../Home/home_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  Future<String> signIn(String contact, password) async {
    print("Exécution de la fonction de connexion ");

    print("Hashage du mot de passe");
    var encodePassword = utf8.encode(password);
    Digest hashpwd = sha256.convert(encodePassword);
    password = hashpwd.toString();

    try {
      print("Tentative d'une connexion");
      Response response = await post(
          Uri.parse('http://164.92.134.116/api/v1/login/'),
          body: jsonEncode(
              <String, String>{"contact": contact, "password": password}),
          headers: <String, String>{"Content-Type": "application/json"});

      print("Code de la reponse : [${response.statusCode}]");
      print("Contenue de la reponse : ${response.body}");
      //String content = response.body.toString();
      //file.writeAsStringSync(content);

      if (response.statusCode == 200) {
        print("La connexion à été éffectué");
        startSession(contact);
        String data = response.body.toString();
        //String data = signInLocal(contact);
        return data;
      } else {
        print("La connexion à échoué");
        return "fail";
      }
    } catch (e) {
      print(e.toString());
      return "fail";
    }
  }

  String signInLocal(String contact) {
    print("SIGN IN LOCAL");
    String path = "./users/$contact.json";
    File file = File(path);
    bool theUserExsist = file.existsSync();

    if (theUserExsist) {
      String contents = file.readAsStringSync();
      return contents;
    } else {
      return "";
    }
  }

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
            decoration: const InputDecoration(
              hintText: "Email ou Numéro",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
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
              decoration: const InputDecoration(
                hintText: "Mot de passe",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
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
                if (contactController.text.toString().isNotEmpty &&
                    passwordController.text.toString().isNotEmpty) {
                  signIn(contactController.text.toString(),
                          passwordController.text.toString())
                      .then((value) {
                    if (value == "fail") {
                      print("Connexion echouée");
                    } else {
                      /*String userData =
                          '{"first_name":"firstname" , "last_name":"lastname","contact":"001122334455","password":"passwordHashed"}';*/
                      Map<String, dynamic> jsonUserData = jsonDecode(value);

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
                    }
                  }).catchError((e) {
                    print("Une erreur est survenue !");
                    print(e);
                  });
                } else {
                  print("Remplissez tous les champ s'il vous plait !");
                }
              },
              child: Text(
                "Connexion".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
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
