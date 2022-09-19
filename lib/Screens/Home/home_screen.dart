import 'package:flutter/material.dart';
import 'package:instapay_master/Screens/Settings/settings.dart';
import '../MainPages/Home/home.dart';
import '../MainPages/SendMoney/send_money.dart';
import '../../components/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageStorageBucket bucket = PageStorageBucket();
  int selectedScreenIndex = 0;
  List<Widget> screenList = [
    const Home(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barre d'application
      appBar: appBar(),

      // Page active
      body: PageStorage(
        bucket: bucket,
        child: screenList[selectedScreenIndex],
      ),

      // Boutton d'action destiner à charger la page pour envoyer de l'argent
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Barre de navigation de bas
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget floatingActionButton() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SendMoney()));
        },
        child: const Icon(Icons.send_outlined),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Instapay",
        style: TextStyle(
            color: kPrimaryColor, fontSize: 30, fontWeight: FontWeight.bold),
      ),
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  debugPrint('Chargement de la page des notifications');
                },
                icon: const Icon(
                  Icons.notifications,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget bottomNavigationBar() {
    return BottomAppBar(
      child: SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonBottomBar(
                label: "Accueil",
                icon:
                    selectedScreenIndex == 0 ? Icons.home : Icons.home_outlined,
                selected: selectedScreenIndex == 0,
                onPressed: () {
                  setState(() {
                    selectedScreenIndex = 0;
                  });
                }),
            ButtonBottomBar(
                label: "Paramètres",
                icon: selectedScreenIndex == 1
                    ? Icons.settings
                    : Icons.settings_outlined,
                selected: selectedScreenIndex == 1,
                onPressed: () {
                  setState(() {
                    selectedScreenIndex = 1;
                  });
                })
          ],
        ),
      ),
    );
  }
}

class ButtonBottomBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  const ButtonBottomBar(
      {Key? key,
      required this.label,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? kPrimaryColor : Colors.grey.shade600,
            size: 30,
          ),
          Text(
            label,
            style: TextStyle(
                color: selected ? kPrimaryColor : Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final String title;
  const Page({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

///
///
///
///
///        PAGES DE TEST
///
///
///
///

class ThemeStyles {
  static TextStyle primaryTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: ThemeColors.black,
  );
  static TextStyle seeAll = TextStyle(
    fontSize: 17.0,
    color: ThemeColors.black,
  );
  // ignore: prefer_const_constructors
  static TextStyle cardDetails = TextStyle(
    fontSize: 17.0,
    color: const Color(0xff66646d),
    fontWeight: FontWeight.w600,
  );
  static TextStyle cardMoney = const TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
  );
  static TextStyle tagText = TextStyle(
    fontStyle: FontStyle.italic,
    color: ThemeColors.black,
    fontWeight: FontWeight.w500,
  );
  static TextStyle otherDetailsPrimary = TextStyle(
    fontSize: 16.0,
    color: ThemeColors.black,
  );
  static TextStyle otherDetailsSecondary = const TextStyle(
    fontSize: 12.0,
    color: Colors.grey,
  );
}

class ThemeColors {
  static Color lightGrey = const Color(0xffE8E8E9);
  static Color black = const Color(0xff14121E);
  static Color grey = const Color(0xFF8492A2);
}

///
///   IconBottom
///   ----------
///
/// Représente les bouttons du menu du bas
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

///
///   TRANSACTIONS
///

