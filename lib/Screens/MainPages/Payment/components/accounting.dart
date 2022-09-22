// CONSTANTES DES COMPTES ET TRANSACTION
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:instapay/components/constants.dart';

const double maximumBalance = 999999999.0;
const double minimumBalance = 0.0;
const int minimumTransferAmount = 500;

/// FRAIS DES OPÉRATEUR

class MoneyWithdrawalFees {
  static double instapay = 100.0;
}

class TransfertFees {
  static const double instapay = 0.01;
}

class Account {
  getBalance(String token, int statusCode, String body) async {
    //http://164.92.134.116/api/v1/users/accounts/
    try {
      Response result = await get(Uri.parse('${api}users/accounts/'),
          headers: {"Authorization": "Bearer $token"});

      debugPrint("  --> Code de la reponse : [${result.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${result.body}");
      statusCode = result.statusCode;
      body = result.body;
    } catch (e) {
      debugPrint("Erreur inconu");
    }
  }
}
