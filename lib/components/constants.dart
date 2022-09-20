import 'package:flutter/material.dart';
const primary = Colors.black;
const secondary = Colors.white;
const mainColor = Color(0xFF000000);
const appBgColor = Colors.white;
const appBgColorPrimary = Color(0xFF7c62fe);
const appBgColorSecondary = Color(0xFF7ec1fe);
const bottomBarColor = Colors.white;
const inActiveIcon = Color(0xFFABBEEC);
const shadowColor = Colors.black87;
const yellow = Color(0xFFffcb66);
const green = Color(0xFFb2e1b5);
const pink = Color(0xFFf5bde8);
const purple = Color(0xFFd9bcff);
const red = Color(0xFFef5013);

// COULEURS GÉNÉRALE
const kPrimaryColor = Color(0xFF613DE6);
const kPrimaryLightColor = Color(0xFFC9C9E4);

const kSimpleTextColor = Color(0xFF7184AD);
const kBoldTextColor = Color(0xFF1F2C73);

const kWeightBoldColor = Color(0xFF080643);

const kBackgroundBodyColor = Color(0xFFF6F9FC);

// COULEURS D'INFORMATION
const Color successColor = Color.fromARGB(255, 35, 127, 38);
const Color errorColor = Colors.red;
const Color warningColor = Color.fromARGB(255, 236, 179, 44);

// DIMENSSIONS PADDING
const double defaultPadding = 16.0;
const double mediumPadding = 32.0;
const double bigMediumPadding = 50;
const double largePadding = 64.0;

// ADRESSE API
const String api = "http://164.92.134.116/api/v1/";
const String apiDomain = "http://164.92.134.116/api/v1/";
//  Adresse de l'API
// 164.92.134.116
// devinstapay.pythonanywhere.com

const int pinLenght = 5;

class Test {
  void debug() {
    debugPrint("Hello world");
  }
}

class Api {
  String variable = "un endpoints";
}

class Bottom {
  static int home = 0;
  static int chat = 0;
  static int settings = 0;
}

class ThemeStyles {
  static TextStyle primaryTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: ThemeColors.black,
  );
  static TextStyle seeAll = TextStyle(
    fontSize: 17.0,
    color: ThemeColors.black,
  );
  // ignore: prefer_const_constructors
  static TextStyle cardDetails = TextStyle(
    fontSize: 17.0,
    color: const Color(0xff66646d),
    fontWeight: FontWeight.w600,
  );
  static TextStyle cardMoney = const TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
  );
  static TextStyle tagText = TextStyle(
    fontStyle: FontStyle.italic,
    color: ThemeColors.black,
    fontWeight: FontWeight.w500,
  );
  static TextStyle otherDetailsPrimary = TextStyle(
    fontSize: 16.0,
    color: ThemeColors.black,
  );
  static TextStyle otherDetailsSecondary = const TextStyle(
    fontSize: 12.0,
    color: Colors.grey,
  );
}

class ThemeColors {
  static Color lightGrey = const Color(0xffE8E8E9);
  static Color black = const Color(0xff14121E);
  static Color grey = const Color(0xFF8492A2);
}



/*

{"refresh":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY2MzYyMzkyNSwianRpIjoiYjA0MWNlOWI2MmZhNDllMTlmNWZmYmM0MmViY2YyMjQiLCJ1c2VyX2lkIjoyNH0.StJwYDzS9hFiraIVFbhttZqpVGZ0oLZ3x2s8Ko17Va4","access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjYzNTY3NTI1LCJqdGkiOiIzZTQyNmY0N2VlOWY0ODhkYjlhODM3NjRiNGQ2Njg4MSIsInVzZXJfaWQiOjI0fQ.GEtSxpcr8VyRaxLd4RM--pkEpKCJffBSn394Setxysg"}

http://164.92.134.116/api/v1/signup/

// Full screen width and height
double width = MediaQuery.of(context).size.width;
double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
var padding = MediaQuery.of(context).viewPadding;
double height1 = height - padding.top - padding.bottom;

// Height (without status bar)
double height2 = height - padding.top;

// Height (without status and toolbar)
double height3 = height - padding.top - kToolbarHeight;
*/