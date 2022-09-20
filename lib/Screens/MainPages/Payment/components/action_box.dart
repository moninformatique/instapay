import 'package:flutter/material.dart';

import '../../../../components/constants.dart';

class ActionBox extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final Color? bgColor;
  final String title;
  final Function() onTap;

  const ActionBox(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.color,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          height: 130,
          padding:
              const EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: bgColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: secondary),
                  child: Icon(
                    icon,
                    size: 28,
                    color: color,
                  )),
              const SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w600),
              )
            ],
          )),
    );
  }
}
