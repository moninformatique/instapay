// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';

import '../login.dart';
import '../../../components/constants.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultRegisterSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultRegisterSize;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  bool obscuretext = true;
  bool loading = false;
  bool isSubmitEnable = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    fullNameController.addListener(() {
      var fullname = fullNameController.text.length >= 5;
      emailController.addListener(() {
        var email = EmailValidator.validate(emailController.text);
        passwordController.addListener(() {
          var password = passwordController.text.length >= 8;
          confirmPasswordController.addListener(
            () {
              var cpassword = confirmPasswordController.text.length >= 8;
              setState(() {
                isSubmitEnable =
                    (fullname && email && password && cpassword) ? true : false;
              });
            },
          );
        });
      });
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: widget.size.width,
            height: widget.defaultRegisterSize,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: bigMediumPadding),

                    // Titre
                    const Text(
                      'Rejoingnez nous',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),

                    // Message
                    Center(
                      child: Text(
                        'InstaPay, simple et sécurisé',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                      ),
                    ),

                    const SizedBox(height: bigMediumPadding * 3),

                    // Formulaire d'inscription
                    Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          // Champ du nom d'utilisateur
                          TextFormField(
                            controller: fullNameController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: "Nom complet",
                            ),
                            validator: (fullname) {
                              return fullname != null && fullname.length < 5
                                  ? "Nom complet trop court"
                                  : null;
                            },
                          ),

                          const SizedBox(height: defaultPadding),

                          // Champ de l'adresse mail
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
                            validator: (value) {
                              if (value != null && value.length < 8) {
                                return "Mot de passe trop court";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),

                          const SizedBox(height: defaultPadding),

                          // Champ de Confirmation du mot de passe
                          TextFormField(
                            controller: confirmPasswordController,
                            obscureText: obscuretext,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Confirmez mot de passe",
                            ),
                            validator: (value) {
                              if (value != null && value.length < 8) {
                                return "Mot de passe trop court";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),

                          const SizedBox(height: mediumPadding),
                          // Champ de soumission du formulaire
                          loading
                              ? const CircularProgressIndicator(
                                  color: kPrimaryColor,
                                  strokeWidth: 5,
                                )
                              :
                              // Boutton inscripton
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      onSurface: kPrimaryColor),
                                  onPressed: isSubmitEnable
                                      ? () {
                                          final isValidForm =
                                              formKey.currentState!.validate();
                                          if (isValidForm) {
                                            debugPrint("Formulaire valide ...");
                                            setState(() {
                                              loading = true;
                                            });
                                            signUp();
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
                                  child: Text("S'inscrire".toUpperCase())),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fonction d'inscription d'un utilisateur
  void signUp() async {
    debugPrint("Exécution de la fonction d'inscription ...");

    // Verifier que tous les champs sont remplis

    // Verifier que les mots de passes correspondent
    if (passwordController.text == confirmPasswordController.text) {
      //hasher le mot de passe avant de l'enoyer à l'api
      var encodePassword = utf8.encode(passwordController.text);
      String passwordHashed = sha256.convert(encodePassword).toString();

      try {
        debugPrint("[..] Inscrition de l'utilisateur ${emailController.text}");
        debugPrint("  --> Envoie de la requete d'inscription");
        Response response = await post(Uri.parse('${api}signup/'),
            body: jsonEncode(<String, String>{
              "full_name": fullNameController.text,
              "email": emailController.text,
              "password": passwordHashed
            }),
            headers: <String, String>{"Content-Type": "application/json"});

        debugPrint("  --> Code de la reponse : [${response.statusCode}]");
        debugPrint("  --> Contenue de la reponse : ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint("[OK] Inscription éffectué avec succès");
          String email = emailController.text;
          emailController.clear();
          fullNameController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          setState(() {
            loading = false;
          });
          openDialog(email);
        } else {
          setState(() {
            loading = false;
          });
          var result = jsonDecode(response.body.toString());
          debugPrint("[X] ${result["erreur"]}");
          showInformation(context, false, "Ce compte existe déjà");
        }
      } catch (e) {
        setState(() {
          loading = false;
        });
        debugPrint("[X] Une erreur est survenue  \n $e");
        showInformation(context, false, "Vérifiez votre connexion internet");
      }
    } else {
      setState(() {
        loading = false;
      });
      debugPrint("[X] Mots de passe difféérents ");
      showInformation(context, false, "Mots de passe différents");
    }
  }

  Future openDialog(String email) => showDialog(
      context: context,
      builder: ((context) => AlertDialog(
            content: Text(
                "Un mail à été envoyé à l'addresse $email pour l'activation de votre compte. Activez votre compte avant de vous connecter"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: const Text(
                    "Bien compris",
                    style: TextStyle(color: kPrimaryColor),
                  ))
            ],
          )));

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
