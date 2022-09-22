// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../login.dart';

import '../../../components/constants.dart';

class ResetPassword extends StatefulWidget {
  final String userEmail;
  const ResetPassword({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  bool isSubmitEnable = false;
  bool resetPassword = false;
  bool obscuretext = true;
  bool loading1 = false;
  bool loading2 = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController restaurationCodeController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController cNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailController.addListener(() {
      var email = EmailValidator.validate(emailController.text);

      setState(() {
        isSubmitEnable = email ? true : false;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(mediumPadding),
          child: Expanded(
            child: Column(children: [
              const SizedBox(
                height: largePadding * 2,
              ),
              // Titre
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Mot de passe oublié ?',
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: kBoldTextColor)),
                    ),
                  ),
                ],
              ),

              // Message
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      !loading1 && !resetPassword
                          ? "Pas de panique !"
                          : (!resetPassword)
                              ? "Vous recevrez un mail à l'addresse ${emailController.text} dans quelques instants."
                              : "Vous avez reçu un code de restauration à l'addresse ${emailController.text}.",
                      style: TextStyle(color: Colors.grey.shade600),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: largePadding * 3,
                  ),
                  // Fonrmulaire de connexion

                  !resetPassword ? confirmEmailForm() : resetPasswordForm(),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Form confirmEmailForm() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Champ de l'adresse Mail
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.alternate_email),
              hintText: "Email du compte",
            ),
            validator: (email) {
              return email != null && !EmailValidator.validate(email)
                  ? "Adresse mail invalide"
                  : null;
            },
          ),
          const SizedBox(height: bigMediumPadding),

          loading1
              ? const CircularProgressIndicator(
                  color: kPrimaryColor,
                  strokeWidth: 5,
                )
              :
              // Boutton de connexion
              ElevatedButton(
                  style: ElevatedButton.styleFrom(onSurface: kPrimaryColor),
                  onPressed: (isSubmitEnable)
                      ? () async {
                          final isValidForm = formKey.currentState!.validate();
                          if (isValidForm) {
                            setState(() {
                              loading1 = true;
                              //resetPassword = true;
                            });
                            debugPrint("Formulaire valide ... ");

                            try {
                              debugPrint(
                                  "[..] Demande de restauration de mot de passe du ${emailController.text}");
                              debugPrint(
                                  "  --> Envoie de la requete de demande de restauration");
                              Response response = await post(
                                  Uri.parse('${api}ask_for_reset_password/'),
                                  body: jsonEncode(<String, dynamic>{
                                    "email": emailController.text,
                                  }),
                                  headers: <String, String>{
                                    "Content-Type": "application/json"
                                  });

                              debugPrint(
                                  "  --> Code de la reponse : [${response.statusCode}]");
                              debugPrint(
                                  "  --> Contenue de la reponse : ${response.body}");

                              if (response.statusCode == 200) {
                                setState(() {
                                  loading1 = false;
                                  resetPassword = true;
                                });
                              } else {
                                showInformation(
                                    context, false, "Compte inexistant");
                                setState(() {
                                  loading1 = false;
                                  resetPassword = false;
                                });
                              }
                            } catch (e) {
                              showInformation(context, false,
                                  "Vérifiez votre connexion internet");
                              setState(() {
                                loading1 = false;
                                resetPassword = false;
                              });
                            }
                          }
                        }
                      : null,
                  child: Text("Confirmer".toUpperCase())),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade500,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Retour".toUpperCase())),
        ],
      ),
    );
  }

  Form resetPasswordForm() {
    return Form(
      key: formKey2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Champ de l'adresse Mail
          TextFormField(
            controller: restaurationCodeController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.pin),
              hintText: "Code de restauration",
            ),
            validator: (code) {
              return code != null && code.length != 10
                  ? "Contient 10 caractères"
                  : null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: newPasswordController,
            obscureText: obscuretext,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscuretext = !obscuretext;
                  });
                },
                child:
                    Icon(obscuretext ? Icons.visibility : Icons.visibility_off),
              ),
              hintText: "Nouveau mot de passe",
            ),
            validator: (password) {
              return password != null && password.length < 8
                  ? "Mot de passe trop court"
                  : null;
            },
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            controller: cNewPasswordController,
            obscureText: obscuretext,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.password),
              hintText: "Confirmez le mot de passe",
            ),
            validator: (password) {
              return password != null && password.length < 8
                  ? "Mot de passe trop court"
                  : null;
            },
          ),
          const SizedBox(height: bigMediumPadding),
          loading2
              ? const CircularProgressIndicator(
                  color: kPrimaryColor,
                  strokeWidth: 5,
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(onSurface: kPrimaryColor),
                  onPressed: (isSubmitEnable)
                      ? () async {
                          final isValidForm = formKey2.currentState!.validate();
                          if (isValidForm) {
                            setState(() {
                              loading2 = true;
                              //resetPassword = true;
                            });
                            debugPrint("Formulaire valide ... ");

                            if (newPasswordController.text ==
                                cNewPasswordController.text) {
                              var encodePassword =
                                  utf8.encode(newPasswordController.text);
                              String passwordHashed =
                                  sha256.convert(encodePassword).toString();
                              try {
                                debugPrint(
                                    "[..] Restauration du mot de passe du ${emailController.text}");
                                debugPrint(
                                    "  --> Envoie de la requete de restauration");
                                Response response = await post(
                                    Uri.parse('${api}reset_password/'),
                                    body: jsonEncode(<String, dynamic>{
                                      "email": emailController.text,
                                      "reset_code":
                                          restaurationCodeController.text,
                                      "new_password": passwordHashed,
                                    }),
                                    headers: <String, String>{
                                      "Content-Type": "application/json"
                                    });

                                debugPrint(
                                    "  --> Code de la reponse : [${response.statusCode}]");
                                debugPrint(
                                    "  --> Contenue de la reponse : ${response.body}");

                                if (response.statusCode == 200) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false);
                                  setState(() {
                                    loading2 = false;
                                    resetPassword = true;
                                  });
                                } else {
                                  showInformation(context, false,
                                      "Informations incorrectes");
                                  setState(() {
                                    loading2 = false;
                                    resetPassword = false;
                                  });
                                }
                              } catch (e) {
                                showInformation(context, false,
                                    "Vérifiez votre connexion internet");
                                setState(() {
                                  loading2 = false;
                                  resetPassword = false;
                                });
                              }
                            } else {
                              setState(() {
                                loading2 = false;
                              });
                              debugPrint("[X] Mots de passe difféérents ");

                              showInformation(
                                  context, false, "Mots de passe différents");
                            }
                          }
                        }
                      : null,
                  child: Text("Restaurer".toUpperCase())),
          const SizedBox(
            height: defaultPadding,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade500,
              ),
              onPressed: () {
                //Navigator.pop(context);
                setState(() {
                  resetPassword = false;
                  restaurationCodeController.clear();
                  newPasswordController.clear();
                  cNewPasswordController.clear();
                });
              },
              child: Text("Retour".toUpperCase())),
        ],
      ),
    );
  }

  showInformation(BuildContext context, bool isSuccess, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
      //behavior: SnackBarBehavior.floating,
      backgroundColor: isSuccess ? successColor : errorColor,
      //elevation: 3,
    ));
  }
}
