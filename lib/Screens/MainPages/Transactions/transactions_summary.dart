import 'package:flutter/material.dart';

import '../../../components/constants.dart';
import 'components/transaction_item.dart';
import 'transactions.dart';

class TransactionsSummary extends StatelessWidget {
  const TransactionsSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Transactions",
                style: TextStyle(
                  color: kBoldTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Transactions()),
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward,
                  color: kWeightBoldColor,
                ),
              ),
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
                children: const [
                  TransactionItem(
                    imageUrl: "assets/images/uba.png",
                    fullName: "Rebecca Lucas",
                    status: "received",
                    amount: "1.030.489",
                  ),
                  TransactionItem(
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
