import 'package:flutter/widgets.dart';

class TransactionModel {
  final String status;
  final String fullName;
  final String imageUrl;
  //final int sender;
  final String amount;
  //final DateTime datetime;

  const TransactionModel({
    required this.status,
    required this.fullName,
    required this.imageUrl,
    //required this.sender,
    required this.amount,
    //required this.datetime,
  });
}

/*
class TransactionModel {
  final bool status;
  final int sender;
  final double amount;
  final DateTime datetime;

  const TransactionModel({
    required this.status,
    required this.sender,
    required this.amount,
    required this.datetime,
  });
}
*/

// ,"status":true,"state":"1","sender":24,"recipient":11