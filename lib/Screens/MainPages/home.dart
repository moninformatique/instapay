// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'component/model.dart';
import '../../components/constants.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic>? data;
  const Home({Key? key, required this.data}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AmountModel> amountList = [
    const AmountModel(
      icon: Icons.currency_franc,
      title: "Fonds disponible",
      amount: '1,600,000 Fcfa',
    ),
    const AmountModel(
      icon: Icons.send,
      title: "Somme transférée",
      amount: '25,000 Fcfa',
    ),
    const AmountModel(
      icon: Icons.currency_exchange,
      title: "Somme réçu",
      amount: '1,625,000 Fcfa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBarBottomSection(),
          mainBody(),
        ],
      ),
    );
  }

  Container appBarBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(color: kPrimaryColor.withOpacity(0.1), width: 2),
              boxShadow: [
                BoxShadow(
                  color: kSecondaryColor.withOpacity(0.4),
                  offset: const Offset(0, 8),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vous disposez de',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '1,600,000',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 0.9,
                      ),
                    ),
                    Text(
                      ' Fcfa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  Expanded mainBody() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Résumé transactions',
                        style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: amountList.length,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 50,
                      height: 60,
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(),
                      child: Icon(
                        amountList[index].icon,
                        size: 30,
                        color: kSecondaryColor,
                      ),
                    ),
                    title: Text(
                      amountList[index].title,
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Text(
                      amountList[index].amount,
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
