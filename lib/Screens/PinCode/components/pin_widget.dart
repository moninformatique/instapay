// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'pin_animation.dart';

class PinController {
  late void Function(String) addInput;
  late void Function() delete;
  late void Function() notifyWrongInput;
}

class PinWidget extends StatefulWidget {
  final int pinLegth;
  final PinController controller;
  final Function(String) onCompleted;

  const PinWidget(
      {Key? key,
      required this.pinLegth,
      required this.controller,
      required this.onCompleted})
      : assert(pinLegth <= 7 && pinLegth > 0),
        super(key: key);
  @override
  _PinWidgetState createState() => _PinWidgetState(controller);
}

class _PinWidgetState extends State<PinWidget>
    with SingleTickerProviderStateMixin {
  late List<PinAnimationController> _animationControllers;
  late AnimationController _wrongInputAnimationController;
  late Animation<double> _wiggleAnimation;
  late String pinCode = '';

  _PinWidgetState(PinController controller) {
    controller.addInput = addInput;
    controller.delete = delete;
    controller.notifyWrongInput = notifyWrongInput;
  }

  void addInput(String input) async {
    pinCode += input;
    if (pinCode.length < widget.pinLegth) {
      _animationControllers[pinCode.length - 1].animate(input);
    } else if (pinCode.length == widget.pinLegth) {
      _animationControllers[pinCode.length - 1].animate(input);
      await Future.delayed(const Duration(milliseconds: 300));
      widget.onCompleted.call(pinCode);
      pinCode = '';
    }
  }

  void delete() {
    if (pinCode.isNotEmpty) {
      pinCode = pinCode.substring(0, pinCode.length - 1);
      _animationControllers[pinCode.length].animate('');
    }
  }

  void notifyWrongInput() {
    _wrongInputAnimationController.forward();
    for (var controller in _animationControllers) {
      controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(widget.pinLegth, (index) {
      return PinAnimationController();
    });

    _wrongInputAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _wrongInputAnimationController.reverse();
        }
      });

    _wiggleAnimation = Tween<double>(begin: 0.0, end: 24.0).animate(
      CurvedAnimation(
          parent: _wrongInputAnimationController, curve: Curves.elasticIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(_wiggleAnimation.value, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.pinLegth, (index) {
          return PinAnimation(
            controller: _animationControllers[index],
          );
        }),
      ),
    );
  }
}
