// ignore_for_file: unused_field, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import '../User/profile.dart';
import '../About/about.dart';
import '../Welcome/welcome_screen.dart';
import 'component/test.dart';
import '../MainPages/receive_money.dart';
import '../MainPages/send_money.dart';
import '../../components/constants.dart';

import '../MainPages/home.dart';
import '../MainPages/transaction.dart';

class MyHomePage extends StatefulWidget {
  final Map<String, dynamic>? data;
  const MyHomePage({Key? key, required this.data}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Home(data: widget.data),
      Transaction(),
      SendMoney(),
      ReceiveMoney(
        userContact: widget.data!['contact'],
      ),
    ];
    List<String> titre = [
      widget.data!["contact"],
      "Transactions",
      "Envoyer",
      "Recevoir"
    ];

    return Scaffold(
      appBar: buildAppBar(titre[_selectedIndex]),
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF501CE2),
        ),
        child: BottomAppBar(
          //elevation: 0,
          //color: Colors.transparent,
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
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
                        text: "Transactions",
                        icon: (_selectedIndex == 0)
                            ? Icons.currency_exchange
                            : Icons.currency_exchange_outlined,
                        selected: _selectedIndex == 1,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        }),
                    IconBottomBar(
                        text: "Envoyer",
                        icon: (_selectedIndex == 2)
                            ? Icons.send
                            : Icons.send_outlined,
                        selected: _selectedIndex == 2,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                        }),
                    IconBottomBar(
                        text: "Recevoir",
                        icon: (_selectedIndex == 3)
                            ? Icons.currency_franc
                            : Icons.currency_franc_outlined,
                        selected: _selectedIndex == 3,
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 3;
                          });
                          Test();
                        }),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(String title) {
    Future<int> logout() async {
      try {
        File sessionUser = File('./sessions/.islogged');
        await sessionUser.delete();
        return 1;
      } catch (e) {
        print(e);
        return 0;
      }
    }

    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: Padding(
        padding: EdgeInsets.only(left: 20, top: 15),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ),
      leadingWidth: 500,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: IconButton(
            onPressed: () {
              print('Chargement de la page des notifications');
              /*
              logout();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const WelcomeScreen();
              }));
              */
            },
            icon: const Icon(Icons.notifications),
          ),
        ),
        PopupMenuButton(
          icon: Image.asset(
            'assets/images/menu.png',
            fit: BoxFit.fitWidth,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "profil",
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: kSecondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Text("Mon profile"),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: "invite",
              child: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: kSecondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Text("Inviter un ami"),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: "about",
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: kSecondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Text("A propos"),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: kSecondaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding),
                    child: Text("Se deconecter"),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case "profil":
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserProfil(
                          data: widget.data,
                        )));
                break;
              case "invite":
                print("Invit your friend");
                break;
              case "about":
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AboutPage()));
                break;
              case "logout":
                logout();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WelcomeScreen();
                }));
                break;
              default:
            }
          },
        ),
      ],
    );
  }
}

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
              size: 25, color: (selected) ? kSecondaryColor : Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            height: .1,
            color: (selected) ? kSecondaryColor : Colors.grey,
          ),
        )
      ],
    );
  }
}
