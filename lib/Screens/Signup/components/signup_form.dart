// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/constants.dart';
import '../../Login/login_screen.dart';
import '../../Home/home_screen.dart';

/*
  // UNE CLASS QUI CONTIENT LES FONCTION DE LECTURE ET D'ECRITURE DANS UN FICHIER
class FileStorage {
  String path = '';
  String data = '';
  FileStorage(String path, String data);

  Future<String> readFile() async {
    try {
      final file = File(path);

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'Error';
    }
  }

  Future<File> writeFile(String path, String data) async {
    final file = File(path);

    // Write the file
    return file.writeAsString(data);
  }
  
}
*/
class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  final int pageIndex = 0;

  Future<File> saveAccount(String path, String data, String user) async {
    File file = File(path);
    File login = File('./sessions/.islogged');
    File session = File('./sessions/$user.json');

    DateTime today = DateTime.now();
    String lastSession = today.toString();
    String sessionData =
        '{\n\t"user" : "$user",\n\t"lastSession" : "$lastSession"\n}';

    login.writeAsString(user);
    session.writeAsString(sessionData);
    print("Sauvegarde du compte");
    return file.writeAsString(data);
  }

  Future<String?> signUp(String lastname, String firstname, String contact,
      String password, String confirmpassword) async {
    print("Lastname : $lastname");
    print("Firstname :$firstname");
    print("Contact : $contact");
    print("Password :$password");
    print("Confirm Password : $confirmpassword");

    if (lastname.isNotEmpty &&
        firstname.isNotEmpty &&
        contact.isNotEmpty &&
        password.isNotEmpty &&
        confirmpassword.isNotEmpty) {
      if (password == confirmpassword) {
        print("Hashage du mot de passe");
        var encodePassword = utf8.encode(password);
        print(encodePassword.toString());

        Digest hashpwd = sha256.convert(encodePassword);
        String passwordHashed = hashpwd.toString();
        print(passwordHashed);
        String data =
            '{\n\t"first_name":"$firstname",\n\t"last_name":"$lastname",\n\t"contact":"$contact",\n\t"password":"$passwordHashed"\n}';
        String path = './users/$contact.json';
        saveAccount(path, data, contact);
        return data;
      } else {
        return null;
      }
    } else {
      return null;
    }

    /*
    try {
      //https://reqres.in/api/register
      Response response = await post(
          Uri.parse('http://devinstapay/pythonanywhere.com/api/v1/signup'),
          body: data);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        print(data['token']);
        print('Account created succefully');
      } else {
        print('Failed');
      }
    } catch (e) {
      print(e.toString());
    }
    */
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
              signUp(
                      lastNameController.text.toString(),
                      firstNameController.text.toString(),
                      contactController.text.toString(),
                      passwordController.text.toString(),
                      confirmPasswordController.text.toString())
                  .then((value) {
                print("------------------------------");
                print(value);
                if (value == null) {
                  print("Inscription echouée");
                } else {
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
              });
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
