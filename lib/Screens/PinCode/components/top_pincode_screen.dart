import 'package:flutter/material.dart';

///
///     TopPincodeScreen
///     ----------------
/// Cette page décris la partie supérieur des interface de saisie de code PIN
///

class TopPincodeScreen extends StatelessWidget {
  final String userImage;
  final String userMessage;
  final String userEmail;
  const TopPincodeScreen(
      {Key? key,
      required this.userImage,
      required this.userMessage,
      required this.userEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo ou Image de profile
        Image.asset(
          userImage,
          height: 100,
          width: 100,
        ),

        // Message
        Text(
          userMessage,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
        ),

        // contact de l'utilisateur présentément connecté
        Text(userEmail),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
