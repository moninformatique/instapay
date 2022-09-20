import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../components/constants.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({
    Key? key,
  }) : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final formKey = GlobalKey<FormState>();
  TextEditingController receiptAddressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController amountToSendController = TextEditingController();
  String mysolde = "0";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      var amount = amountController.text;
      setState(() {
        if (amount.isNotEmpty) {
          amountToSendController.text =
              "${double.parse(amount) + (double.parse(amount) * 0.01)}";
        } else {
          amountToSendController.clear();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo sur la carte
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
            // CAdresse mail du destinataire
            TextFormField(
              onChanged: (value) {},
              controller: receiptAddressController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email du recepteur",
              ),
              validator: (email) {
                return email != null && !EmailValidator.validate(email)
                    ? "Adresse mail invalide"
                    : null;
              },
            ),
            const SizedBox(
              height: defaultPadding,
            ),

            // Montant à transférer
            TextFormField(
              onChanged: (value) {},
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
                    ? !(int.parse(amount) % 100 == 0)
                        ? "Doit être un multiple de 100"
                        : null
                    : null;
              },
            ),

            const SizedBox(
              height: defaultPadding,
            ),

            // Montant à transférer + frais
            TextFormField(
              onChanged: (value) {},
              controller: amountToSendController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                filled: false,
                prefixIcon: const Icon(Icons.currency_franc),
                label: Text(
                  "Montant credité",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),

            const SizedBox(height: bigMediumPadding),

            loading
                ? const CircularProgressIndicator(
                    color: kPrimaryColor,
                    strokeWidth: 5,
                  )
                :
                // Boutton de connexion
                ElevatedButton(
                    style: ElevatedButton.styleFrom(onSurface: kPrimaryColor),
                    onPressed: () async {
                      final isValidForm = formKey.currentState!.validate();
                      if (isValidForm) {
                        setState(() {
                          loading = true;
                        });
                        debugPrint("Formulaire valide ... ");
                      }
                    },
                    child: Text("Confirmer".toUpperCase())),
          ],
        ),
      ),
    );
  }
}

/*
  void accountRequest(String userID) async {
    Map<String, dynamic> account = jsonDecode("{}");

    debugPrint("Tentative de recupération des infos solde");
    Response response = await get(Uri.parse('${api}users/$userID/accounts/'));

    debugPrint("Code de la reponse : [${response.statusCode}]");
    debugPrint("Contenue de la reponse : ${response.body}");

    if (response.statusCode == 200) {
      String userAccountData = response.body.toString();
      Map<String, dynamic> tmp = jsonDecode(userAccountData);

      account = tmp['account_owner'][0];
      debugPrint("Retour du solde du client");
      mysolde = account['amount'].toString();
    } else {
      debugPrint("La requete e échouée");
      mysolde = "0";
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //accountRequest(widget.userID);
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBarBottomSection(),
          const SizedBox(
            height: 20,
          ),
          mainBody(),
        ],
      ),
    );
  }



  Expanded mainBody() {
    return Expanded(
      child: Column(
        children: [
          Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: defaultPadding, horizontal: defaultPadding),
              child: Column(
                children: [
                  TextFormField(
                    controller: destinationAddressController,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    //onSaved: (email) {},
                    decoration: InputDecoration(
                      hintText: "Adresse du destinataire",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: kPrimaryColor)),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.qr_code),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  TextFormField(
                    controller: amountToSendController,
                    textInputAction: TextInputAction.done,
                    cursorColor: kPrimaryColor,
                    decoration: InputDecoration(
                      hintText: "Montant à transferer",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.currency_franc),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: kPrimaryColor)),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Montant restant"),
                      Text(
                          "${double.parse(widget.solde) - double.parse((amountToSendController.text.isNotEmpty) ? amountToSendController.text : "0.0")}"),
                    ],
                  ),*/
                  const SizedBox(height: defaultPadding * 2),
                  FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    onPressed: () async {
                      String response = await FlutterBarcodeScanner.scanBarcode(
                          '#ffffff', 'retour', true, ScanMode.QR);
                      debugPrint(
                          "==========================================================================================");
                      debugPrint(response);
                    },
                    child: const Icon(
                      Icons.qr_code_scanner_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding,
                        horizontal: defaultPadding * 3),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (int.parse(widget.solde) >
                            int.parse((amountToSendController.text.isNotEmpty)
                                ? amountToSendController.text
                                : "0")) {
                          if (widget.receiveCode !=
                              destinationAddressController.text) {
                            try {
                              debugPrint("Tentative d'envoie d'argent");
                              Response response = await post(
                                  Uri.parse('${api}transactions/'),
                                  body: jsonEncode(<String, String>{
                                    "user_id": widget.userID,
                                    "send_code": widget.sendCode,
                                    "receive_code":
                                        destinationAddressController.text,
                                    "amount": amountToSendController.text
                                  }),
                                  headers: <String, String>{
                                    "Content-Type": "application/json"
                                  });

                              debugPrint(
                                  "Code de la reponse : [${response.statusCode}]");
                              debugPrint(
                                  "Contenue de la reponse : ${response.body}");

                              if (response.statusCode == 200) {
                                debugPrint("Transaction reussie");
                              } else {
                                debugPrint("Transaction échouée");
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Text("Transaction inutile")],
                            )));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Votre solde est insuffisant")
                            ],
                          )));
                        }
                      },
                      child: const Text(
                        "Envoyer",
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
*/
