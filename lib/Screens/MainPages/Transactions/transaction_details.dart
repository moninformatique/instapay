// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../../components/constants.dart';

class TransactionsDetails extends StatefulWidget {
  final String title;
  final String subTitle;
  final String price;
  final String letter;
  final Color color;
  const TransactionsDetails({
    Key? key,
    required this.color,
    required this.letter,
    required this.price,
    required this.subTitle,
    required this.title,
  }) : super(key: key);
  
  @override
  _TransactionsDetailsState createState() => _TransactionsDetailsState();
}

class _TransactionsDetailsState extends State<TransactionsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),

                // Montant Réçu
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("+${widget.price}",
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                color: kWeightBoldColor,
                              )),
                          Text("Réçu de ${widget.title}"),
                          const Text("Effectuée",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: largePadding,
                ),
                // Date et heure
                OtherDetailsItem(
                    label: "Date et Heure", info: "18 Septembre 2022"),
                OtherDetailsDivider(),

                // Montant transféré
                OtherDetailsItem(
                    label: "Montant transféré", info: "538.000 Fcfa"),

                OtherDetailsDivider(),

                // Frais de transfert
                OtherDetailsItem(label: "Frais", info: "20 Fcfa"),
                OtherDetailsDivider(),

                // ID de la transaction
                OtherDetailsItem(
                    label: "ID transaction", info: "YRBU38FUAHRXEIY"),

                OtherDetailsDivider(),

                // Opérateur de la transaction
                OtherDetailsItem(label: "Opérateur", info: "MTN Mobile Money"),
                OtherDetailsDivider(),

                TextButton(
                    onPressed: () => debugPrint("Imprimer réçu"),
                    child: Text(
                      "Impprimer le réçu",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ),
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
        "Détails de transaction",
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
    );
  }
}

class OtherDetailsDivider extends StatelessWidget {
  const OtherDetailsDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        color: Colors.grey.withOpacity(0.4),
        thickness: 0.5,
        indent: 16,
        endIndent: 16,
      ),
    );
  }
}

class OtherDetailsItem extends StatelessWidget {
  final String label;
  final String info;
  const OtherDetailsItem({Key? key, required this.label, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: ThemeStyles.otherDetailsSecondary),
            SizedBox(height: 5.0),
            Text(info, style: ThemeStyles.otherDetailsPrimary),
          ],
        ),
      ],
    );
  }
}
