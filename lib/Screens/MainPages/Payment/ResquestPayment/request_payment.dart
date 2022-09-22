import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../components/constants.dart';
import '../components/accounting.dart';
import '../components/protection_code_screen.dart';

class RequestPayment extends StatefulWidget {
  final Map<String, dynamic> tokens;
  const RequestPayment({
    Key? key,
    required this.tokens,
  }) : super(key: key);

  @override
  State<RequestPayment> createState() => _RequestPaymentState();
}

class _RequestPaymentState extends State<RequestPayment> {
  // Clé du formulaire d'envoi d'argent
  final formKey = GlobalKey<FormState>();

  // Controlleur des champ du formulaire
  TextEditingController receiptAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  // Frais de la transaction montant à envoyer multiplier par 1%
  double transactionFees = 0.0;
  // Montant total à préléver du compte de l'utilisateur
  double amountToSend = 0.0;

  bool loading = false;
  bool checkBoxSelected = false;
  bool submitEnabled = false;
  bool emailIsValid = false;
  bool amountIsValid = false;
  bool accountProtection = false;
  String date = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              const SizedBox(
                height: largePadding,
              ),

              // Formulaire d'envoi d'argent
              sendMoneyForm(),
            ],
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
        "Requête de paiement",
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

  Widget sendMoneyForm() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Adresse mail du destinataire
            TextFormField(
              controller: receiptAddressController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email du destinataire",
              ),
              validator: (email) {
                return email != null && !EmailValidator.validate(email)
                    ? "Email invalide"
                    : null;
              },
            ),

            const SizedBox(
              height: defaultPadding,
            ),

            // Montant demander
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.currency_franc),
                hintText: "Montant demandé",
              ),
              validator: (amount) {
                return amount != null && amount.isNotEmpty
                    ? !(int.parse(amount) % 100 == 0)
                        ? "Doit être multiple de 100"
                        : null
                    : null;
              },
            ),

            const SizedBox(
              height: defaultPadding,
            ),

            // Raison de la requete
            TextFormField(
              controller: reasonController,
              minLines: 2,
              maxLines: 7,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: "Motif de votre requète",
              ),
              validator: (message) {
                return message != null && message.isEmpty
                    ? "Le motif est important"
                    : null;
              },
            ),

            const SizedBox(height: bigMediumPadding * 4),

            const SizedBox(height: defaultPadding),
            /*loading
                ? const CircularProgressIndicator(
                    color: kPrimaryColor,
                    strokeWidth: 5,
                  )
                :*/
            // Boutton de connexion

            ElevatedButton(
                style: ElevatedButton.styleFrom(onSurface: kPrimaryColor),
                onPressed: () async {
                  final isValidForm = formKey.currentState!.validate();
                  if (isValidForm) {
                    setState(() {
                      //loading = true;
                    });
                    debugPrint(
                        "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&Formulaire valide ... ");
                    if (accountProtection) {
                      var data = {
                        "receiver": receiptAddressController.text,
                        "amount": amountToSend,
                        "date": date
                      };
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProtectionCodeScreen(
                                    data: data,
                                    tokens: widget.tokens,
                                  )));
                    } else {
                      sendRequest();
                    }
                  }
                },
                child: Text("Confirmer".toUpperCase())),
          ],
        ),
      ),
    );
  }

  getAccountProtection() async {
    debugPrint(
        "################ GET ACCOUNT PROTECTION##########################");
    debugPrint("${widget.tokens}");
    try {
      Response response = await get(Uri.parse('${api}users/accounts/'),
          headers: {"Authorization": "Bearer ${widget.tokens['access']}"});

      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        setState(() {
          debugPrint("Initialisation de accountProtection");
          accountProtection = result["account_protection"];
          debugPrint(
              " @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@à ACCOUNT PROTECTION $accountProtection @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint("##########################################");
  }

  void getDate() {
    debugPrint("DATE");
    var now = DateTime.now();
    var dtFormatted = DateFormat('yyyy-MM-dd');
    setState(() {
      date = dtFormatted.format(now);
      debugPrint(date);
    });
  }

  sendRequest() async {
    try {
      Response response = await post(Uri.parse("${api}users/transactions/"),
          headers: {
            "Authorization": "Bearer ${widget.tokens['access']}",
            "Content-type": "application/json"
          },
          body: jsonEncode({
            "receiver": receiptAddressController.text,
            "amount": amountController.text,
            "reason": reasonController.text
          }));

      if (response.statusCode == 200) {
        debugPrint("paiement éffectué");
        debugPrint('le contenu de la reponse : ${response.body}');
        openDialog("Requete envoyée", true);
      } else {
        debugPrint("echec du paiement : ${response.body}");
        openDialog("Requête non envoyée", false);
      }
    } catch (e) {
      debugPrint("erreur : ${e.toString()}");
    }
  }

  Future openDialog(String message, bool status) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: Container(
              height: 150,
              child: Column(
                children: [
                  Icon(
                    status ? Icons.check_circle : Icons.error,
                    color: status ? successColor : errorColor,
                    size: 100,
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  Text(message),
                ],
              ),
            ),
          )));
}
