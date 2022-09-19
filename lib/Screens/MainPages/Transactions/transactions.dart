import 'package:flutter/material.dart';

import '../../../components/constants.dart';
import 'components/search_bar.dart';
import 'components/transaction_item.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  int active = 0;
  bool switcher = false;
  static int tous = 0;
  static int entrant = 1;
  static int sortant = 2;
  List navBarIndex = [0, 1, 2];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barre de recherche
            const SearchBar(
              hintText: "Nom ou Email",
              iconData: Icons.search,
            ),

            // Barre de navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                navBar(tous, "Tous"),
                navBar(entrant, "Entrants"),
                navBar(sortant, "Sortants"),
              ],
            ),

            const SizedBox(
              height: mediumPadding,
            ),

            // Liste des transactions
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Statistiques",
                      style: TextStyle(
                        color: kBoldTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    statsItem("Entrants", "284.048", true),
                    statsItem("Sortants", "994.562", false),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    const Divider(
                      color: kPrimaryColor,
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: mediumPadding,
                    ),
                    (active == tous)
                        ? allTransactions()
                        : (active == entrant)
                            ? incomingTransactions()
                            : outcomingTransactions(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Transactions",
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back,
          color: kPrimaryColor,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.notifications,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget navBar(int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          active = index;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: defaultPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: (index == active) ? kPrimaryColor : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: (index == active) ? Colors.white : Colors.grey[400],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Row statsItem(String label, String amount, bool income) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icone et label
        Row(
          children: [
            //Icone
            Icon(
              income
                  ? Icons.arrow_circle_down_rounded
                  : Icons.arrow_circle_up_rounded,
              color: income ? Colors.green : Colors.red,
              size: 30,
            ),
            const SizedBox(
              width: 20,
            ),

            // Label
            Text(
              label,
              style: const TextStyle(
                color: kBoldTextColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // Montant
        Text(
          "+ $amount F",
          style: TextStyle(
            color: income ? Colors.green : Colors.red,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // liste de toutes les transactions
  Column allTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // Titre
        Text(
          "Toutes les transactions",
          style: TextStyle(
            color: kBoldTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),

        // Date
        Text(
          "Septembre 2022",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),

        // Lites de transactions à cette date
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Janice Brewer",
          status: "received",
          amount: "114.00",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Phoebe Buffay",
          status: "sended",
          amount: "70.16",
        ),
        SizedBox(
          height: defaultPadding,
        ),

        // Date
        Text(
          "Août 2022",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),

        // Liste de transactions à cette date
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Monica Geller",
          status: "received",
          amount: "44.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Rachel Green",
          status: "sended",
          amount: "85.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Kamila Fros",
          status: "received",
          amount: "155.00",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Ross Geller",
          status: "received",
          amount: "23.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Chandler Bing",
          status: "received",
          amount: "11.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Yoyi Delirio",
          status: "received",
          amount: "36.00",
        ),
      ],
    );
  }

  // Liste des transctions entrantes
  Column incomingTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // Titre
        Text(
          "Transactions entrantes",
          style: TextStyle(
            color: kBoldTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),

        // Date
        Text(
          "Septembre 2022",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),

        // Liste de transactions à cette date
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Janice Brewer",
          status: "received",
          amount: "114.00",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Phoebe Buffay",
          status: "received",
          amount: "70.16",
        ),
        SizedBox(
          height: defaultPadding,
        ),

        // Date
        Text(
          "Août 2022",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),

        // liste de transactions à cette date
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Monica Geller",
          status: "received",
          amount: "44.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Rachel Green",
          status: "received",
          amount: "85.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Yoyi Delirio",
          status: "received",
          amount: "36.00",
        ),
      ],
    );
  }

  // Liste des transactions sortantes
  Column outcomingTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // Titre
        Text(
          "Transactions sortantes",
          style: TextStyle(
            color: kBoldTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),

        // Date
        Text(
          "Septembre 2022",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),

        // Liste des transactions à une date
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Janice Brewer",
          status: "sended",
          amount: "114.00",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Phoebe Buffay",
          status: "sended",
          amount: "70.16",
        ),
        SizedBox(
          height: defaultPadding,
        ),

        // Date
        Text(
          "Août 2022",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),

        // Liste des transactions a un date
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Kamila Fros",
          status: "sended",
          amount: "155.00",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Ross Geller",
          status: "sended",
          amount: "23.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Chandler Bing",
          status: "sended",
          amount: "11.50",
        ),
        TransactionItem(
          imageUrl: "assets/images/orange.png",
          fullName: "Yoyi Delirio",
          status: "sended",
          amount: "36.00",
        ),
      ],
    );
  }
}
