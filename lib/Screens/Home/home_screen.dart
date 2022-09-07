import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Login/login.dart';
import '../MainPages/receive_money.dart';
import '../MainPages/send_money.dart';
import '../../../components/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainPages/home.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const HomeScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String mysolde = "0";
  String sendCode = "";
  String receiveCode = "";

  void accountRequest(String userID) async {
    Map<String, dynamic> account = jsonDecode("{}");

    try {
      debugPrint("Tentative de recupération des infos solde");
      Response response = await get(Uri.parse('${api}users/$userID/accounts/'));

      debugPrint("Code de la reponse : [${response.statusCode}]");
      debugPrint("Contenue de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        String userAccountData = response.body.toString();
        Map<String, dynamic> tmp = jsonDecode(userAccountData);

        account = tmp['account_owner'][0];
        debugPrint("Retour du solde du client");
        mysolde = account['amount'].toString();
      } else {
        debugPrint("La requete e échouée");
        mysolde = "0";
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {});
  }

  void userDataRequest(String userID) async {
    debugPrint("USERDATA REQUEST - RECEIVE PAGE");

    try {
      debugPrint(
          "Tentative de recupération des infos utilisateurs [${api}users/$userID/]");
      Response responseAccount = await get(Uri.parse('${api}users/$userID/'));

      debugPrint("Code de la reponse : [${responseAccount.statusCode}]");
      debugPrint("Contenue de la reponse : ${responseAccount.body}");

      if (responseAccount.statusCode == 200) {
        Map<String, dynamic> tmp = jsonDecode(responseAccount.body.toString());

        debugPrint("Retour du solde du client");

        sendCode = tmp['send_code'].toString();
        receiveCode = tmp['receive_code'].toString();
        debugPrint("Votre code d'envoi est  : $sendCode");
        debugPrint("Votre code de reception est  : $receiveCode");
      } else {
        debugPrint("La requete e échouée");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    accountRequest(widget.userData['user_id']);
    userDataRequest(widget.userData['user_id']);
    List<Widget> screens = [
      Home(userID: widget.userData['user_id'], solde: mysolde),
      SendMoney(
        userID: widget.userData['user_id'],
        solde: mysolde,
        sendCode: sendCode,
        receiveCode: receiveCode,
      ),
      ReceiveMoney(userID: widget.userData['user_id'], solde: mysolde, receiveCode: receiveCode,)
    ];
    List<String> titles = [widget.userData['contact'], "Envoyer", "Recevoir"];

    return Scaffold(
      appBar: buildAppBar(titles[_selectedIndex]),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF501CE2),
        ),
        child: BottomAppBar(
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconBottomBar(
                        text: "Accueil",
                        icon: (_selectedIndex == 0)
                            ? Icons.home
                            : Icons.home_outlined,
                        selected: _selectedIndex == 0,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        }),
                    IconBottomBar(
                        text: "Envoyer",
                        icon: (_selectedIndex == 1)
                            ? Icons.send
                            : Icons.send_outlined,
                        selected: _selectedIndex == 1,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        }),
                    IconBottomBar(
                        text: "Recevoir",
                        icon: (_selectedIndex == 2)
                            ? Icons.currency_franc
                            : Icons.currency_franc_outlined,
                        selected: _selectedIndex == 2,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        }),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  ///
  ///
  ///

  AppBar buildAppBar(String title) {
    logout() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear();
    }

    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kBackgroundColor,
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: IconButton(
              onPressed: () {
                debugPrint('Chargement de la page des notifications');
              },
              icon: const Icon(Icons.notifications),
            ),
          ),

          // popup menu déroullante
          PopupMenuButton(
            icon: Image.asset(
              'assets/icons/menu.png',
              fit: BoxFit.fitWidth,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "profil",
                child: Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: kBoldTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultPadding),
                      child: Text("Mon profile"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "invite",
                child: Row(
                  children: const [
                    Icon(
                      Icons.share,
                      color: kBoldTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultPadding),
                      child: Text("Inviter un ami"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "setting",
                child: Row(
                  children: const [
                    Icon(
                      Icons.settings,
                      color: kBoldTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultPadding),
                      child: Text("Paramètres"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "about",
                child: Row(
                  children: const [
                    Icon(
                      Icons.info,
                      color: kBoldTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultPadding),
                      child: Text("A propos"),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: kBoldTextColor,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: defaultPadding),
                      child: Text("Se déconecter"),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case "profil":
                  break;
                case "invite":
                  debugPrint("Inviter un ami");
                  break;
                case "about":
                  break;
                case "logout":
                  logout();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                  break;
                default:
              }
            },
          ),
        ]);
  }
}

///
///   IconBottom
///   ----------
///
/// Représente les bouttons du menu du bas
///
///
///

class IconBottomBar extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  const IconBottomBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon,
              size: 25, color: (selected) ? kPrimaryColor : Colors.grey),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            height: .1,
            color: (selected) ? kPrimaryColor : Colors.grey,
          ),
        )
      ],
    );
  }
}
