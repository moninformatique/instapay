// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/constants.dart';
import 'Screens/Login/login.dart';
import 'Screens/PinCode/pin_code.dart';

// Définition des noms de route vers les pages qui peuvent être lancer au démarrage de laplication
const String pinCodeScreenRoute = "pincode";
const String loginScreenRoute = "login";

// Classe qui définit les paramètres dans l'initialisation
class InitData {
  // Lle texte à partager avec la page suivante
  final String sharedText;
  // Le nom de la route suivante
  final String routeName;

  InitData(this.sharedText, this.routeName);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  InitData initData = await init();

  runApp(MyApp(
    initData: initData,
  ));
}

// Cette fonction initiaise les données de l'utilisateur s'il elles existe
// et coisi par conséquent la page qui doit être lancer
Future<InitData> init() async {
  String sharedText = "";
  String routeName = loginScreenRoute;

  debugPrint("[..] Recherche d'une session ");
  // Recherche de données utilisateur enregistrée dans la memoire de l'appareil
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? data = pref.getString("user");

  if (data != null) {
    debugPrint("[$data est déjà connecté]");
    sharedText = data;
    routeName = pinCodeScreenRoute;
  } else {
    debugPrint("[Aucun utilisateur connecté]");
  }

  debugPrint("[OK] Recherche d'une session");
  return InitData(sharedText, routeName);
}

///     MyApp
///     -----
/// Widget racine de l'application

class MyApp extends StatefulWidget {
  final InitData initData;
  const MyApp({Key? key, required this.initData}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'instapay',

      // Définition de style globale
      theme: ThemeData(
          primaryColor: kSimpleTextColor,
          scaffoldBackgroundColor: kBackgroundBodyColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            //fillColor: Color.fromARGB(255, 227, 224, 224),
            //iconColor: kWeightBoldColor,
            //prefixIconColor: kWeightBoldColor,
            iconColor: Colors.grey,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none),
          )),

      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case loginScreenRoute:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case pinCodeScreenRoute:
            return MaterialPageRoute(
                builder: (_) => PinCodeAuth(
                      userEmail: widget.initData.sharedText,
                    ));
        }
        return null;
      },
      initialRoute: widget.initData.routeName,
      /*home: (isLogged)
          ? PinCodeAuth(userEmail: userEmail.toString())
          : const LoginScreen(),*/
    );
  }
}
