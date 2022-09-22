import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../components/constants.dart';
import 'components/transaction_item.dart';

class TransactionsSummary extends StatefulWidget {
  final String token;
  const TransactionsSummary({Key? key, required this.token}) : super(key: key);

  @override
  State<TransactionsSummary> createState() => _TransactionsSummaryState();
}

class _TransactionsSummaryState extends State<TransactionsSummary> {
  var inTransactions;
  var outTransactions;
  var usersTransactions;
  var listOfUsers;
  var totalUsers;
  var allTransactionsUsers;

  @override
  void initState() {
    setState(() {
      debugPrint("Initstate transations umary");
      getTransactions(widget.token);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Transactions",
                style: TextStyle(
                  color: kBoldTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              /*
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  Transactions(token: widget.token,)),
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  color: kWeightBoldColor,
                ),
              ),*/
            ],
          ),
          const SizedBox(
            height: defaultPadding,
          ),

          // Résumé des transactions
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  (outTransactions != null && listOfUsers != null)
                      ? ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: outTransactions.length,
                          itemBuilder: (context, index) => TransactionItem(
                            transaction: outTransactions[index],
                            flow: "out",
                            list: listOfUsers[index],
                          ),
                        )
                      : Container(),
                  (inTransactions != null && listOfUsers != null)
                      ? ListView.separated(
                          primary: false,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: inTransactions.length,
                          itemBuilder: (context, index) => TransactionItem(
                            transaction: inTransactions[index],
                            flow: "in",
                            list: listOfUsers[index],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: const [
                                SizedBox(
                                  height: largePadding,
                                ),
                                Text(
                                  "Aucune transaction éffectuée",
                                  style: TextStyle(
                                      color: kBoldTextColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getTransactions(String token) async {
    try {
      Response response = await get(Uri.parse('${api}users/transactions/'),
          headers: {"Authorization": "Bearer $token"});

      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          var transactions = jsonDecode(response.body);
          outTransactions = transactions["sender"];
          inTransactions = transactions["recipient"];
          allTransactionsUsers = inTransactions + outTransactions;
          List<int>? userId = getUserId(inTransactions, outTransactions);
          getUsers(widget.token, userId);
        });
      } else {
        setState(() {
          inTransactions = null;
          outTransactions = null;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        inTransactions = null;
        outTransactions = null;
      });
    }
  }

  List<int>? getUserId(var intrans, var outtrans) {
    debugPrint(
        "-/////////////////////// debut  getUserID/////////////////////////////");
    var userIdList = <int>[];
    //totalUsers = [];
    if (intrans != null && outtrans != null) {
      for (var element in outtrans) {
        //if (!userIdList.contains(element["recipient"])) {
        userIdList.add(element["recipient"]);
        //totalUsers.add(element);
        //}
      }
      for (var element in intrans) {
        //if (!userIdList.contains(element["sender"])) {
        userIdList.add(element["sender"]);
        //totalUsers.add(element);
        //}
      }
      //totalUsers.sort((a, b) => b["id"].compareTo(a["id"]));
      debugPrint(
          "-/////////////////////// userID ok/////////////////////////////");
      return userIdList;
    } else {
      debugPrint(
          "-/////////////////////// userID non OK/////////////////////////////");
      return null;
    }
  }

  getUsers(String token, var userId) async {
    debugPrint(
        "-/////////////////////// debut  getUser/////////////////////////////");
    try {
      Response response = await post(Uri.parse('${api}users/'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-type": "application/json"
          },
          body: jsonEncode({
            "get_user_info": userId,
          }));

      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        debugPrint(
            "-/////////////////////// getUsers ok/////////////////////////////");

        setState(() {
          var users = jsonDecode(response.body);
          usersTransactions = users["response"];
          setUserList(usersTransactions, userId);
        });
      } else {
        debugPrint(
            "-/////////////////////// getuser pas  ok/////////////////////////////");
        setState(() {
          usersTransactions = null;
        });
      }
    } catch (e) {
      debugPrint(
          "-/////////////////////// getUsers pas ok/////////////////////////////");
      debugPrint(e.toString());
      setState(() {
        usersTransactions = null;
      });
    }
  }

  setUserList(var usersTrans, var userId) {
    debugPrint(
        "-/////////////////////// debut  setUser ///////////////////////////// \n $usersTrans");
    var list = [];
    var element = {};

    if (usersTrans != null) {
      var temp = usersTrans;

      for (var i = 0; i < temp.length; i++) {
        var endIndex = temp[i].indexOf("/", 0);
        element["id"] = userId![i];
        element["mail"] = temp[i].substring(0, endIndex);
        element["username"] = temp[i].substring(endIndex + 1, temp[i].length);
        list.add(element);
      }
      listOfUsers = list;
      debugPrint(
          "-//////////////////////////////// fin ////////////////////////////////////////");
      debugPrint("$listOfUsers");
    }
  }

  sortTransactions() {
    int inIndex = 0;
    int outindex = 0;
    outTransactions = outTransactions.reversed;
    inTransactions = inTransactions.reversed;
    /*while (
        inIndex < inTransactions.length || outindex < outTransactions.length) {}*/
    debugPrint("${outTransactions.reversed}");

/*
    debugPrint(" Liste initiale ");
    debugPrint("$outTransactions");
    debugPrint("Liste triée ");
    debugPrint("$decode");*/
  }
}
/*
        "id": 2,
        "amount": 30500,
        "datetime_transfer":"2022-09-20 11:23:30",
        "status": true,
        "stats":"1",
        "sender": 28,
        "recipient": 14

        + id_transaction :  sha(id),
        + amount
        + datetime
        + status
        + stats
        - senderUsername
        - senderEmail
        - flow (in, out)

*/


/*
// RESUME DES TRANSACTIONS

Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: const [
                  TransactionItem(
                    imageUrl: "assets/images/uba.png",
                    fullName: "Rebecca Lucas",
                    status: "received",
                    amount: "1.030.489",
                  ),
                  /*TransactionItem(
                    imageUrl: "assets/logos/4-rb.png",
                    fullName: "Jose Young",
                    status: "sended",
                    amount: "19.63",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/4-rb.png",
                    fullName: "Janice Brewer",
                    status: "received",
                    amount: "114.00",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/5-rb.png",
                    fullName: "Phoebe Buffay",
                    status: "received",
                    amount: "70.16",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/4.png",
                    fullName: "Monica Geller",
                    status: "received",
                    amount: "44.50",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/5.png",
                    fullName: "Rachel Green",
                    status: "sended",
                    amount: "85.50",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/4-rb.png",
                    fullName: "Kamila Fros",
                    status: "received",
                    amount: "155.00",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/4-rb.png",
                    fullName: "Ross Geller",
                    status: "received",
                    amount: "23.50",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/4-rb.png",
                    fullName: "Chandler Bing",
                    status: "received",
                    amount: "11.50",
                  ),
                  TransactionItem(
                    imageUrl: "assets/logos/4-rb.png",
                    fullName: "Yoyi Delirio",
                    status: "received",
                    amount: "36.00",
                  ),*/
                
                ],
              ),
            ),
          ),


          */