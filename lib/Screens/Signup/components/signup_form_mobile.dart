// ignore_for_file: must_be_immutable, avoid_print

import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../Home/home_screen.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/constants.dart';
import '../../Login/login_screen.dart';

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

class SignUpFormMobile extends StatefulWidget {
  const SignUpFormMobile({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpFormMobile> createState() => _SignUpFormMobileState();
}

class _SignUpFormMobileState extends State<SignUpFormMobile> {
  late int pageIndex = 0;

  int nombreDePage = 3;

  Future<File> saveAccount(String path, String data) async {
    File file = File(path);
    // Write the file
    print("Sauvegarde du compte");
    return file.writeAsString(data);
  }

  Future<String?> signUp(
      String lastname,
      String firstname,
      String email,
      String number,
      String cninumber,
      String password,
      String confirmpassword) async {
    print("Lastname : $lastname");
    print("Firstname :$firstname");
    print("Email : $email");
    print("Number :$number");
    print("CniNumber : $cninumber");
    print("Password :$password");
    print("Confirm Password : $confirmpassword");

    if (password == confirmpassword) {
      String data =
          '{"lastname":"$lastname","firstname":"$firstname","email":"$email","number":"$number","cni":"$cninumber","password":"$password"}';
      String path = './users/$number.json';
      saveAccount(path, data);
      return data;
    } else {
      return null;
    }

    /*
    try {
      Response response = await post(
          Uri.parse('https://reqres.in/api/register'),
          body: {'email': email, 'password': password});

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
    TextEditingController emailController = TextEditingController();

    TextEditingController lastNameController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController numberController = TextEditingController();
    TextEditingController cniNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Form(
      child: Column(
        children: (pageIndex == 0)
            ? [
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
                  onEditingComplete: () {},
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: TextFormField(
                    controller: firstNameController,
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
                ElevatedButton(
                  onPressed: () {
                    //pageIndex = 1;
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: Text("Suivant".toUpperCase()),
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
              ]
            : (pageIndex == 1)
                ? [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        onSaved: (email) {},
                        decoration: const InputDecoration(
                          hintText: "Adresse electronique",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.mail),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: numberController,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Numéro de téléphone",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.numbers),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        controller: cniNumberController,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Numero CNI",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.numbers),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        //pageIndex = 1;
                        setState(() {
                          pageIndex = 2;
                        });
                      },
                      child: Text("Suivant".toUpperCase()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 5.0,
                          vertical: defaultPadding),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            pageIndex = 0;
                          });
                        },
                        child: const Text('Retour'),
                      ),
                    ),
                  ]
                : [
                    TextFormField(
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
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
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
                    ElevatedButton(
                      onPressed: () {
                        signUp(
                                lastNameController.text.toString(),
                                firstNameController.text.toString(),
                                emailController.text.toString(),
                                numberController.text.toString(),
                                cniNumberController.text.toString(),
                                passwordController.text.toString(),
                                confirmPasswordController.text.toString())
                            .then((value) {
                          print("------------------------------");
                          print(value);
                          if (value == null) {
                            print("Inscription echouée");
                          } else {
                            Map<String, dynamic> jsonUserData =
                                jsonDecode(value);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 5.0,
                          vertical: defaultPadding),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            pageIndex = 1;
                          });
                        },
                        child: const Text('Retour'),
                      ),
                    ),
                  ],
      ),
    );
  }
}

class SignUpForm1 extends StatelessWidget {
  const SignUpForm1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Message 1"),
      ],
    );
  }
}
