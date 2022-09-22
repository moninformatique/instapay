import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../transaction_details.dart';
import '../../../../components/constants.dart';

/*

        "id": 2,
        "amount": 30500,
        "datetime_transfer":"2022-09-20 11:23:30",
        "status": true,
        "stats":"1",
        "sender": 28,
        "recipient": 14
*/

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;
  var list;
  final String flow;

  TransactionItem(
      {Key? key,
      required this.transaction,
      required this.flow,
      required this.list})
      : super(key: key);
//list.indexWhere((i) => i['id'] == item['id'])
  @override
  Widget build(BuildContext context) {
    String image = "assets/logos/4-rb.png";
    getDate(transaction["datetime_transfer"]);
    debugPrint("$transaction");

    return GestureDetector(
      onTap: () {
        /*
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionsDetails(
                    color: kWeightBoldColor,
                    letter: "A",
                    price: "537.980",
                    subTitle: "subTitle",
                    title: "Anxowin")));*/
      },
      child: Row(children: [
        // Image du provider
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Expediteur et Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom complet de l'expéditeur
              Text(
                list["mail"],
                style: const TextStyle(
                  color: kBoldTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Date de la transaction
              Text(
                getDate(transaction["datetime_transfer"]),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Montant de la transaction
        Text(
          (flow == "in")
              ? "+ ${transaction["amount"]}"
              : "- ${transaction["amount"]}",
          style: TextStyle(
            color: (flow == "in") ? Colors.green : Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(Icons.keyboard_arrow_right),
      ]),
    );
  }

  String getDate(String date) {
    DateTime dt = DateTime.parse(date);
    var formatted = DateFormat('yyyy-MM-dd');

    var dtFormatted = formatted.format(dt);
    return dtFormatted;
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

        - id_transaction :  sha(id),
        - amount
        - datetime
        - status
        - stats
        - senderUsername
        - senderEmail
        - flow (in, out)

*/