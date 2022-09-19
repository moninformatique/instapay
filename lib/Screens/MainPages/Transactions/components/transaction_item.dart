import 'package:flutter/material.dart';
import 'package:instapay_master/Screens/MainPages/Transactions/transaction_details.dart';
import '../../../../components/constants.dart';

class TransactionItem extends StatelessWidget {
  final String fullName;
  final String status;
  final String imageUrl;
  final String amount;

  const TransactionItem(
      {Key? key,
      required this.fullName,
      required this.status,
      required this.imageUrl,
      required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionsDetails(
                    color: kWeightBoldColor,
                    letter: "A",
                    price: "537.980",
                    subTitle: "subTitle",
                    title: "Anxowin")));
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
              image: AssetImage(imageUrl),
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
                fullName,
                style: const TextStyle(
                  color: kBoldTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Date de la transaction
              Text(
                "18/09/22  15:09",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Montant de la transaction
        Text(
          "${status == "received" ? "+ " : "- "}$amount F",
          style: TextStyle(
            color: status == "received" ? Colors.green : Colors.red,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Icon(Icons.keyboard_arrow_right),
      ]),
    );
  }
}
