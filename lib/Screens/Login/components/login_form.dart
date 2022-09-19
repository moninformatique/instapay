// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'reset_password.dart';
import '../login_double_authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../PinCode/create_pin_code.dart';
import '../../../components/constants.dart';

///
///     LoginForm
///     ---------
/// Dans ce Widget est contruit le formulaire de connexion
///

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool obscuretext = true;
  bool forgetPassword = false;
  bool isSubmitEnable = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.addListener(() {
      var email = EmailValidator.validate(emailController.text);
      passwordController.addListener(() {
        var password = passwordController.text.length >= 8;

        setState(() {
          isSubmitEnable = (email && password) ? true : false;
        });
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
            child: Column(
              children: [
                // Titre
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'InstaPay',
                      style: GoogleFonts.ultra(
                          textStyle: const TextStyle(
                              fontSize: 35, color: kPrimaryColor)),
                    ),
                  ],
                ),

                // Message
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome !",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),

                // Formulaire
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: largePadding * 3,
                    ),
                    // Fonrmulaire de connexion
                    Form(
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
                              hintText: "Email",
                            ),
                            validator: (email) {
                              return email != null &&
                                      !EmailValidator.validate(email)
                                  ? "Adresse mail invalide"
                                  : null;
                            },
                          ),

                          const SizedBox(height: defaultPadding),
                          // Champ du mot de passe
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscuretext,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscuretext = !obscuretext;
                                  });
                                },
                                child: Icon(obscuretext
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              hintText: "Mot de passe",
                            ),
                            validator: (password) {
                              return password != null && password.length < 8
                                  ? "Mot de passe trop court"
                                  : null;
                            },
                          ),

                          const SizedBox(height: defaultPadding),
                          if (forgetPassword)
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResetPassword(
                                                userEmail: emailController.text,
                                              )));
                                },
                                child: const Text(
                                  "Mot de passe oublié ?",
                                  style: TextStyle(color: kWeightBoldColor),
                                )),
                          const SizedBox(height: mediumPadding),
                          // Champ de soumission du formulaire
                          loading
                              ? const CircularProgressIndicator(
                                  color: kPrimaryColor,
                                  strokeWidth: 5,
                                )
                              :
                              // Boutton de connexion
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      onSurface: kPrimaryColor),
                                  onPressed: (isSubmitEnable)
                                      ? () {
                                          final isValidForm =
                                              formKey.currentState!.validate();
                                          if (isValidForm) {
                                            debugPrint(
                                                "Formulaire valide ... ");
                                            setState(() {
                                              loading = true;
                                            });
                                            signIn();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                    "Vos informations ne sont pas valides")
                                              ],
                                            )));
                                          }
                                        }
                                      : null,
                                  child: Text("Se connecteer".toUpperCase())),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fonction de traitement de la connexion au serveur
  void signIn() async {
    debugPrint("Exécution de la fonction de connexion ... ");

    // Variable de sauvegarde de donnée en local
    SharedPreferences pref = await SharedPreferences.getInstance();

    //Hasher le mot de passe avant de l'enoyer à l'api
    var encodePassword = utf8.encode(passwordController.text);
    String passwordHashed = sha256.convert(encodePassword).toString();

    try {
      debugPrint("[..] Connexion de l'utilisateur ${emailController.text} ");
      Response response = await post(Uri.parse('${api}login/token/'),
          body: "email=${emailController.text}&password=$passwordHashed",
          headers: {"Content-Type": "application/x-www-form-urlencoded"});

      debugPrint("  --> Envoie de la requete de connexion");
      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("[OK] Connexion éffectué avec succès");

        // Sauvegarde des données de l'utilisateur en local
        await pref.setString("token", response.body.toString());
        await pref.setString("user", emailController.text);

        // Vérification de la présence d'une double authentification
        var result = jsonDecode(response.body);
        verifyIfDoubleAuthenticationIsActive(result["access"]);
      } else {
        debugPrint("[X] Connexion échoué : HTTP ${response.statusCode}");
        setState(() {
          loading = false;
        });
        if (response.statusCode == 401) {
          setState(() {
            forgetPassword = true;
          });
          showInformation(context, false,
              "Ces informations ne correspondent a aucun compte actif");
        } else {
          showInformation(context, false, "Verifiez votre connexion internet");
        }
      }
    } catch (e) {
      debugPrint("[X] Une erreur est survenue : \n $e");
      setState(() {
        loading = false;
      });
      showInformation(context, false, "Vérifiez votre connexion internet");
    }
  }

  // Verifier si l'utilisateur à activer la double authentification  pour son compte
  void verifyIfDoubleAuthenticationIsActive(String token) async {
    debugPrint(
        "Exécution de la fonction de verification de double authentification ... ");

    try {
      debugPrint("[..] Verification de la double authentification ");
      Response response = await get(Uri.parse('${api}users/'),
          headers: <String, String>{"Authorization": "Bearer $token"});

      debugPrint(
          "  --> Envoie de la requete de verification de la double authentification");
      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("[OK] vérification reussie avec succès");
        var result = jsonDecode(response.body);
        if (result["double_authentication"]) {
          debugPrint("[OK] Double authentification activé");
          sendRequestForDoubleAuthentication(token);
        } else {
          setState(() {
            loading = false;
          });
          debugPrint("[OK] Double authentification déactivé");
          goToCreatePinCodeScreen(emailController.text);
        }
      } else {
        setState(() {
          loading = false;
        });
        debugPrint("[X] Vérification échoué : HTTP ${response.statusCode}");

        showInformation(context, false, "Verifiez votre connexion internet");
      }
    } catch (e) {
      debugPrint("[X] Une erreur est survenue : \n $e");
      setState(() {
        loading = false;
      });
      showInformation(context, false, "Vérifiez votre connexion internet");
    }
  }

  //Fonction de requete pour l'obtention d'un code pour valider la double authentification
  void sendRequestForDoubleAuthentication(String token) async {
    debugPrint(
        "Exécution de la fonction d'envoi de requete pour le code de la double authentification ... ");

    try {
      debugPrint(
          "[..] Requete de demande de code pour la double authentification ");
      Response response = await get(
          Uri.parse('${api}login/second_authentication/'),
          headers: <String, String>{"Authorization": "Bearer $token"});

      debugPrint(
          "  --> Envoie de la requete de demande de code pour la double authentification");
      debugPrint("  --> Code de la reponse : [${response.statusCode}]");
      debugPrint("  --> Contenue de la reponse : ${response.body}");

      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        debugPrint(
            "[OK] Requete de demande de code pour la double authentification reussie avec succès");

        goToDoubleAuthenticationScreen(token, emailController.text);
      } else {
        debugPrint("[X] Vérification échoué : HTTP ${response.statusCode}");

        showInformation(context, false, "Verifiez votre connexion internet");
      }
    } catch (e) {
      debugPrint("[X] Une erreur est survenue : \n $e");
      setState(() {
        loading = false;
      });
      showInformation(context, false, "Vérifiez votre connexion internet");
    }
  }

  // Fonction de chargement de la page de creation de code PIN
  void goToCreatePinCodeScreen(String userEmail) {
    debugPrint(" Chargement de la page de creation de code pin");
    emailController.clear();
    passwordController.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePinCode(userEmail: userEmail)),
        (route) => false);
  }

  // Fonction de chargement de la page de validation de la double authentification
  void goToDoubleAuthenticationScreen(String token, String email) {
    debugPrint(
        " Chargement de la page de validation de double authentification");
    emailController.clear();
    passwordController.clear();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DoubleAuthentication(
                  userToken: token,
                  userEmail: email,
                )));
  }

  // Affiche des informations en rapport avec les resultats des requetes à l'utilisateur
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
