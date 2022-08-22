// ignore_for_file: sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import '../../constants.dart';
import 'package:flutter/material.dart';

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
}
