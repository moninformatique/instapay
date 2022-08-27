// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../components/constants.dart';
import 'component/model.dart';

class Transaction extends StatefulWidget {
  final String solde;
  const Transaction({Key? key, required this.solde}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<TransactionModel> transactionList = [
    const TransactionModel(
      icon: Icons.call_received,
      name: "Kouassi Ezechiel",
      date: '26/08/2022 - 21:05',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Kienou Chris",
      date: '20/08/2022 - 10:05',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_made,
      name: "Ballo Seydou",
      date: '20/08/2022 - 7:32',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Nade Fabrice",
      date: '15/08/2022 - 12:04',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Coulibaly Karim",
      date: '16/08/2022 - 13:59',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_made,
      name: "Kaddy Kaddy",
      date: '22/07/2022 - 21:05',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Soumahoro keh",
      date: '01/02/2022 - 8:10',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Mambe moïse",
      date: '26/01/2022 - 9:3',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Kessy Salomon",
      date: '26/01/2022 - 20:05',
      amount: '---------',
    ),
    const TransactionModel(
      icon: Icons.call_received,
      name: "Ouattara Kader",
      date: '10/01/2022 - 19:30',
      amount: '---------',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: buildAppBar(),
      body: Column(
        children: <Widget>[
          appBarBottomSection(),
          mainBody(),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: kPrimaryColor,
      leading: const Padding(
        padding: EdgeInsets.only(left: 20, top: 15),
        child: Text(
          "Transactions",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
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
            onPressed: () => print('Chargement de la page des notifications'),
            icon: const Icon(Icons.notifications),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () => print('Chargement du menu'),
            icon: Image.asset(
              'assets/images/menu.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Fonds total",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 0.9,
                  )),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.solde,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  height: 0.9,
                ),
              ),
              const Text(
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
          const SizedBox(
            height: 8,
          ),
          /*Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),*/
          const SizedBox(
            height: 32,
          ),
          const SizedBox(
            height: 20,
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
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(),
                      child: Icon(transactionList[index].icon, size: 20),
                    ),
                    title: Text(
                      transactionList[index].name,
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      transactionList[index].date,
                      style: TextStyle(
                        color: kSecondaryColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      transactionList[index].amount,
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
