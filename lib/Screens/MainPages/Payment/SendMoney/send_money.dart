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

class SendMoney extends StatefulWidget {
  final double balance;
  final String receiptEmail;
  final Map<String, dynamic> tokens;
  const SendMoney(
      {Key? key,
      required this.balance,
      required this.tokens,
      this.receiptEmail = ""})
      : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  // Clé du formulaire d'envoi d'argent
  final formKey = GlobalKey<FormState>();

  // Controlleur des champ du formulaire
  TextEditingController receiptAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

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
    getAccountProtection();
    debugPrint("########## ${widget.receiptEmail} ##############");
    receiptAddressController.text = widget.receiptEmail;

    receiptAddressController.addListener(() {
      setState(() {
        if (EmailValidator.validate(receiptAddressController.text)) {
          emailIsValid = true;
        } else {
          emailIsValid = false;
        }
      });
    });

    amountController.addListener(() {
      var amount = amountController.text;

      setState(() {
        if (amount.isNotEmpty) {
          // Frais de la transaction
          transactionFees = double.parse(amount) * TransfertFees.instapay;

          amountToSend = double.parse(amount) + transactionFees;

          debugPrint("${(amountToSend < widget.balance)}");
          debugPrint("${(int.parse(amount) % 100 == 0)}");
          debugPrint("${receiptAddressController.text.isNotEmpty}");
          if (((amountToSend < widget.balance) &&
              (int.parse(amount) % 100 == 0) &&
              receiptAddressController.text.isNotEmpty)) {
            amountIsValid = true;
          } else {
            amountIsValid = false;
          }
        } else {
          amountToSend = 0.0;
          submitEnabled = false;
        }
      });
    });
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
                height: defaultPadding,
              ),

              // Informations sur l'opérateur du transfert
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Information sur l'opérateur du transfert
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      children: [
                        // Logo de l'opérateur
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                              color: kBackgroundBodyColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Image.asset(
                              "assets/logos/4-rb.png",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        // Nom de l'opérateur
                        const Text(
                          "InstaPay",
                          style: TextStyle(
                            color: kWeightBoldColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
              ),

              // Informations sur le solde
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Votre sole : "),
                  Text(
                    "${widget.balance} Fcfa",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding,
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
        "Transfert d'argent",
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
                hintText: "Email du bénéficiaire",
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

            // Montant à transférer
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                filled: false,
                prefixIcon: const Icon(Icons.currency_franc),
                label: Text(
                  "Montant à envoyer",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              validator: (amount) {
                return amount != null && amount.isNotEmpty
                    ? (amountToSend > widget.balance)
                        ? "Solde insuffisant"
                        : !(int.parse(amount) % 100 == 0)
                            ? "Doit être multiple de 100"
                            : null
                    : null;
              },
            ),

            // Confirmer le paiement des frais de retrait
            Row(
              children: [
                Checkbox(
                    activeColor: kPrimaryColor,
                    value: checkBoxSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          checkBoxSelected = value;
                          if (checkBoxSelected) {
                            amountToSend += MoneyWithdrawalFees.instapay;
                          } else {
                            amountToSend -= MoneyWithdrawalFees.instapay;
                          }

                          emailIsValid = EmailValidator.validate(
                                  receiptAddressController.text)
                              ? true
                              : false;
                          if (amountController.text.isNotEmpty) {
                            amountIsValid = ((amountToSend < widget.balance) &&
                                    (int.parse(amountController.text) % 100 ==
                                        0) &&
                                    receiptAddressController.text.isNotEmpty)
                                ? true
                                : false;
                          } else {
                            amountIsValid = false;
                          }
                        }
                      });
                    }),
                const SizedBox(
                  width: 5,
                ),
                const Text("Je paie les frais de retrait")
              ],
            ),

            const SizedBox(height: bigMediumPadding * 4),

            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Frais de retrait : ",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                    "${checkBoxSelected ? MoneyWithdrawalFees.instapay : 0.0} Fcfa",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Frais de l'opération : ",
                  style: TextStyle(fontSize: 12),
                ),
                Text("$transactionFees Fcfa",
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Montant total à payer : ",
                  style: TextStyle(
                      fontSize: 12,
                      color: (emailIsValid && amountIsValid)
                          ? successColor
                          : errorColor),
                ),
                Text("$amountToSend Fcfa",
                    style: TextStyle(
                        fontSize: 12,
                        color: (emailIsValid && amountIsValid)
                            ? successColor
                            : errorColor)),
              ],
            ),
            const Divider(),

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
                onPressed: (emailIsValid && amountIsValid)
                    ? () async {
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
                            sendMoneyToSomeone();
                          }
                        }
                      }
                    : null,
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

  sendMoneyToSomeone() async {
    debugPrint("DATE");
    var now = DateTime.now();
    var dtFormatted = DateFormat('yyyy-MM-dd');
    setState(() {
      date = dtFormatted.format(now);
      debugPrint(date);
    });
    try {
      Response response = await post(Uri.parse("${api}users/transactions/"),
          headers: {
            "Authorization": "Bearer ${widget.tokens['access']}",
            "Content-type": "application/json"
          },
          body: jsonEncode({
            "receiver": receiptAddressController.text,
            "amount": amountToSend,
            "date": date
          }));

      if (response.statusCode == 200) {
        debugPrint("paiement éffectué");
        debugPrint('le contenu de la reponse : ${response.body}');
        openDialog("Transaction éffectué", true);
      } else {
        debugPrint("echec du paiement : ${response.body}");
        openDialog("Transaction echouée", false);
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
