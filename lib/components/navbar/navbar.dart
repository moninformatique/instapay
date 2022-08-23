import 'package:flutter/material.dart';
//import 'component/setting_screen.dart';

class NavBar extends StatelessWidget {
  //final Map<String, dynamic>? userData;
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Nom et prenom"),
            accountEmail: Text("Email"),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètre'),
            onTap: () {
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>   SettingScreen(
                            data: userData,
                          )));
                        */
            },
          ),
        ],
      ),
    );
  }
}
