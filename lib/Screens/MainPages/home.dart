import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../components/constants.dart';
import 'component/model.dart';

class Home extends StatefulWidget {
  final String userID;
  final String solde;
  const Home({Key? key, required this.userID, required this.solde})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String mysolde = "0";
  dynamic transactionsItem;

  void accountRequest(String userID) async {
    Map<String, dynamic> account = jsonDecode("{}");

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
    setState(() {});
  }

  ///
  ///
  ///
  ///
  ///
  void transactionsRequest(String userID) async {
    debugPrint("TRANSACTIONS REQUEST - HOME");

    try {
      debugPrint(
          "Tentative de recupération des infos des transactions [${api}users/$userID/accounts/]");
      Response responseTransactions =
          await get(Uri.parse('${api}users/$userID/transactions/'));

      debugPrint("Code de la reponse : [${responseTransactions.statusCode}]");
      debugPrint("Contenue de la reponse : ${responseTransactions.body}");

      if (responseTransactions.statusCode == 200) {
        Map<String, dynamic> tmp =
            jsonDecode(responseTransactions.body.toString());

        debugPrint("Retour du solde du client");
        transactionsItem = tmp['user_sender'];
        debugPrint("Transactions : $transactionsItem");
      } else {
        debugPrint("La requete e échouée");
        transactionsItem = null;
        debugPrint("Transactions  : $transactionsItem");
      }
    } catch (e) {
      debugPrint(e.toString());
      transactionsItem = null;
    }
    //setState(() {});
  }

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
    //accountRequest(widget.userID);
    transactionsRequest(widget.userID);
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
    //String solde = "999.999.999";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: kWeightBoldColor,
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(color: kPrimaryColor.withOpacity(0.1), width: 2),
              boxShadow: [
                BoxShadow(
                  color: kSimpleTextColor.withOpacity(0.4),
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
                  children: [
                    Text(
                      widget.solde,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
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
              ],
            ),
          ),
          const SizedBox(
            height: 50,
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
                          color: kBoldTextColor,
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
                /*
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
                        color: kPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      transactionList[index].date,
                      style: TextStyle(
                        color: kPrimaryColor.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      transactionList[index].amount,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                */
                transactionsWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionsWidget() {
    if (transactionsItem == null || transactionsItem == [] as dynamic) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Text("Aucune transaction éffectuée")],
      );
    }
     else {
      return ListView.separated(
        primary: false,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(),
        itemCount: transactionsItem.length,
        itemBuilder: (context, index) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 60,
            height: 60,
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            child: (transactionsItem[index]["sender"] == widget.userID)
                ? const Icon(Icons.call_made, size: 20)
                : const Icon(Icons.call_received, size: 20),
          ),
          title: Text(
            transactionsItem[index]["recipient"],
            style: const TextStyle(
              color: kWeightBoldColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "${transactionsItem[index]["datetime"]}",
            style: TextStyle(
              color: kWeightBoldColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Text(
            "${transactionsItem[index]["amount"]}",
            style: const TextStyle(
              color: kWeightBoldColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
  }
}
