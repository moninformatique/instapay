// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
<<<<<<< HEAD
import './../../components/constants.dart';
=======
import 'package:instapay_master/components/constants.dart';
>>>>>>> c4ee9f80b9f545db8351d78b43476cfc88dac89f
import 'package:shared_preferences/shared_preferences.dart';

class UserInformationProfile extends StatefulWidget {
  const UserInformationProfile({Key? key}) : super(key: key);

  @override
  State<UserInformationProfile> createState() => _UserInformationProfileState();
}

class _UserInformationProfileState extends State<UserInformationProfile> {
  Map<String, dynamic> userInformation = {};
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  Map<String, dynamic> tokens = {};
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

  saveUserInformation() async {
    try {
      Response response = await put(Uri.parse("${api}users/profil/"),
          body: jsonEncode(<String, String>{
            "full_name": name.text,
            "email_user": email.text,
            "phone_number": phone.text
          }),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer ${tokens['access']}"
          });

      debugPrint("le code de la reponnse : ${response.statusCode}");
      debugPrint("le contenu de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        await openDialog("Vos informations, ont bien\n été mise à jours.");
      } else {
        await openDialog("une erreur est survenu!\n veuillez réessayer");
      }
    } catch (e) {
      debugPrint("une erreur est survenue : ${e.toString()}");
    }
  }

  Future openDialog(String text) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Merci"))
            ],
          )));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInformation();
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'mes informtions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: kPrimaryColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const Text(
                "Mes informations",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding * 2),
                child: TextFormField(
                  controller: name,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    hintText: userInformation['full_name'].toString() == "null"
                        ? "-"
                        : userInformation['full_name'].toString(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding * 2),
                child: TextFormField(
                  controller: email,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    hintText: userInformation['email'].toString() == "null"
                        ? "-"
                        : userInformation['email'].toString(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.mail),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding, horizontal: defaultPadding * 2),
                child: TextFormField(
                  controller: phone,
                  textInputAction: TextInputAction.done,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    fillColor: Colors.white70,
                    hintText:
                        userInformation['phone_number'].toString() == "null"
                            ? "aucun contact"
                            : userInformation['phone_number'].toString(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: kPrimaryColor)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.numbers),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Retour",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await saveUserInformation();
                    },
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "Modifier",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
