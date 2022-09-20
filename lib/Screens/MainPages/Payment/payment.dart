import 'package:flutter/material.dart';
import './ResquestPayment/request_payment.dart';
import './ScheduleSendMoney/schedule_send_money.dart';
import './SendMoney/send_money.dart';

import '../../../components/constants.dart';
import 'components/action_box.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
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
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                actionsButtons(),
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
        "Opérations",
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

  actionsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: ActionBox(
          title: "Transfert",
          icon: Icons.send,
          bgColor: green,
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SendMoney()));
          },
        )),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: ActionBox(
          title: "Planifier",
          icon: Icons.edit_calendar, //edit_calendar_sharp
          bgColor: purple,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleSendMoney()));
          },
        )),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: ActionBox(
          title: "Demande",
          icon: Icons.arrow_circle_down_rounded,
          bgColor: yellow,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RequestPayment()));
          },
        )),
      ],
    );
  }
}
