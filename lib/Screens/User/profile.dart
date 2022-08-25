import 'package:flutter/material.dart';
import '../../components/constants.dart';

class UserProfil extends StatelessWidget {
  final Map<String, dynamic>? data;
  const UserProfil({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmNewPasswordController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Mon profile"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 100,
              ),
              Text(
                "AHIN AXEL",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  height: 0.9,
                ),
              ),
            ],
          ),
          Divider(),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Nom : ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data!["last_name"],
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Prénoms : ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data!["first_name"],
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.numbers,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Contact : ",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data!["contact"],
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Changer de mot de passe",
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: TextFormField(
              controller: newPasswordController,
              textInputAction: TextInputAction.next,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                hintText: "Saisisez le mode passe actuel",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: kSecondaryColor)),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding * 2),
            child: TextFormField(
              controller: confirmNewPasswordController,
              textInputAction: TextInputAction.done,
              //obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                fillColor: Colors.white70,
                hintText: "Saisisez le nouveau mot de passe",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: kSecondaryColor)),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Confirmer le fial essu"),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
