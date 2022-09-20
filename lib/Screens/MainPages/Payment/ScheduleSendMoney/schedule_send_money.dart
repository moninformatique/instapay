import 'package:flutter/material.dart';
import '../../../../components/constants.dart';

class ScheduleSendMoney extends StatefulWidget {
  const ScheduleSendMoney({
    Key? key,
  }) : super(key: key);

  @override
  State<ScheduleSendMoney> createState() => _ScheduleSendMoneyState();
}

class _ScheduleSendMoneyState extends State<ScheduleSendMoney> {
  TextEditingController destinationAddressController = TextEditingController();
  TextEditingController amountToSendController = TextEditingController();
  String mysolde = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(
                  height: kToolbarHeight,
                ),
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
        "Transfert planifier",
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
