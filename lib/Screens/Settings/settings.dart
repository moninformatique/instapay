// ignore_for_file: use_build_context_synchronously

/*import 'package:flutter/material.dart';
import 'constants.dart';

class SettingScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const SettingScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PARATRÈMES'),
        leading: const Icon(Icons.settings),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: ListView(
          children: [
            ListTile(
              title: Text("Nom : " + data!['lastname']),
              onTap: () {},
            ),
            ListTile(
              title: Text("Prenoms : " + data!['firstname']),
              onTap: () {},
            ),
            ListTile(
              title: Text("Email : " + data!['email']),
              onTap: () {},
            ),
            ListTile(
              title: Text("Numero de téléphone: " + data!['number']),
              onTap: () {},
            ),
            ListTile(
              title: Text("Numéro CNI : " + data!['cni']),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}*/
// ignore_for_file: file_names, avoid_unnecessary_containers, camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Login/login.dart';
import 'change_password.dart';
import 'userInformations.dart';
import '../../components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, dynamic> userInformation = {};
  Map<String, dynamic> userAccountsInfo = {};
  Map<String, dynamic> tokens = {};
  int? optSecured = 1;
  int? dblOAuth = 1;

  getUserInformation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      tokens = jsonDecode(pref.getString("token")!);
    });
    try {
      Response response = await get(Uri.parse("${api}users/"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer ${tokens['access']}"
      });

      if (response.statusCode == 200) {
        String data = response.body.toString();
        var jsonData = jsonDecode(data);
        setState(() {
          userInformation = jsonData;
        });
        debugPrint("result = ${userInformation}");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint(
        "je suis à la fin de la fonction getUserInformation : ${userInformation}");
  }

  secondOAuthValue(int? index) async {
    try {
      Response response = (index == 0
          ? await patch(
              Uri.parse("${api}users/security/?double_authentication=1"),
              body:
                  jsonEncode(<String, dynamic>{"double_authentication": true}),
              headers: {
                  "Content-type": "application/json",
                  "Authorization": "Bearer ${tokens['access']}"
                })
          : await patch(
              Uri.parse("${api}users/security/?double_authentication=0"),
              body:
                  jsonEncode(<String, dynamic>{"double_authentication": false}),
              headers: {
                  "Content-type": "application/json",
                  "Authorization": "Bearer ${tokens['access']}"
                }));
      if (response.statusCode == 200) {
        setState(() {
          debugPrint("je suis dans le setState");
          dblOAuth = index;
        });

        if (index == 0) {
          logout();
        }
      } else {
        debugPrint("echec de la requtes code = ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("une erreur est survenue : ${e.toString()}");
    }
    setState(() {});
  }

  securedOpt(String code, int? index) async {
    debugPrint("le code saisi est : $code");
    debugPrint("l'index est : $index");
    try {
      Response response = index == 1
          ? await patch(Uri.parse("${api}users/security/?account_protection=1"),
              body: jsonEncode(
                  <String, dynamic>{"account_protection_code": code}),
              headers: {
                  "Content-type": "application/json",
                  "Authorization": "Bearer ${tokens['access']}"
                })
          : await patch(Uri.parse("${api}users/security/?account_protection=0"),
              body: jsonEncode(
                  <String, dynamic>{"account_protection_code": code}),
              headers: {
                  "Content-type": "application/json",
                  "Authorization": "Bearer ${tokens['access']}"
                });

      debugPrint("le code de la reponse : ${response.statusCode}");
      debugPrint("le contenu de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          optSecured = index;
        });
        debugPrint("les options de sécurité ont été activé");
      } else {
        debugPrint("erreur : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("une erreur est survenu : ${e.toString()}");
    }

    setState(() {});
  }

  logout() async {
    try {
      Response response = await post(Uri.parse("${api}logout/"),
          body: jsonEncode(<String, dynamic>{"refresh": tokens['refresh']}),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer ${tokens['access']}"
          });
      debugPrint("le code de la reponse est : ${response.statusCode}");
      debugPrint("le contenu de la reponse est : ${response.body}");

      if (response.statusCode == 200) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.clear();

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      }
    } catch (e) {
      debugPrint("une erreur est survenu : ${e.toString()}");
    }
  }

  getAccount() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      tokens = jsonDecode(pref.getString("token")!);
      debugPrint("la tokens est : ${tokens}");
    });
    try {
      Response response =
          await get(Uri.parse("${api}users/accounts/"), headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer ${tokens['access']}"
      });
      debugPrint(
          "code de la reponse pour les informations du compte : ${response.statusCode}");
      debugPrint("le contenu de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        String data = response.body.toString();
        var jsonData = jsonDecode(data);
        setState(() {
          userAccountsInfo = jsonData;
        });
      }
    } catch (e) {
      debugPrint("erreur : ${e.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInformation();
    getAccount();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Text(
              "Paramètres",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Mon compte",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            optionWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserInformationProfile()));
              },
              data: "informations sur mon compte",
            ),
            const SizedBox(
              height: 10,
            ),
            optionWidget(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserProfil()));
              },
              data: "changer mon mot de passe",
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: const [
                Icon(
                  Icons.security_rounded,
                  color: kPrimaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Sécurité",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Options de sécurité",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 120, 119, 119)),
                  ),
                  ToggleSwitch(
                    minWidth: size.width * 0.1,
                    minHeight: 25,
                    cornerRadius: 10,
                    activeBgColor: const [Color.fromARGB(255, 21, 19, 152)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: kPrimaryLightColor,
                    inactiveFgColor: kPrimaryColor,
                    totalSwitches: 2,
                    labels: const ['On', 'Off'],
                    initialLabelIndex:
                        userAccountsInfo['account_protection'].toString() ==
                                "false"
                            ? optSecured
                            : 0,
                    onToggle: (index) async {
                      await showDialog(
                          context: context,
                          builder: ((context) {
                            TextEditingController securedCode =
                                TextEditingController();
                            return AlertDialog(
                              content: Form(
                                  child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: securedCode,
                                    validator: (value) {
                                      return value!.isNotEmpty
                                          ? null
                                          : "remplissez le champs";
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "code de sécurité"),
                                  )
                                ],
                              )),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await securedOpt(securedCode.text, index);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("valider"))
                              ],
                            );
                          }));
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "double authentification",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 120, 119, 119)),
                ),
                ToggleSwitch(
                  minWidth: size.width * 0.1,
                  minHeight: 25,
                  cornerRadius: 10,
                  activeBgColor: const [Color.fromARGB(255, 21, 19, 152)],
                  activeFgColor: Colors.white,
                  inactiveBgColor: kPrimaryLightColor,
                  inactiveFgColor: kPrimaryColor,
                  initialLabelIndex:
                      (userInformation['double_authentication'].toString() ==
                              "true"
                          ? 0
                          : 1),
                  totalSwitches: 2,
                  labels: const ['On', 'Off'],
                  onToggle: (index) async {
                    debugPrint("index = $index");
                    secondOAuthValue(index);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: OutlinedButton(
                onPressed: () async {
                  await logout();
                },
                child: const Text(
                  "Déconnexion",
                  style: TextStyle(
                      fontSize: 16, letterSpacing: 2.2, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class optionWidget extends StatelessWidget {
  final Function onTap;
  final String data;
  const optionWidget({Key? key, required this.onTap, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
