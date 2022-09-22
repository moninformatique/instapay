# Ceci est un fichier texte

https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html

$ flutter pub get 
$ flutter pub run flutter_launcher_icons:main

$ flutter pub run flutter_native_splash:create


SingleChildScrollView(child : Widget)

# Polices Goolgle

Ultra



/*
--------------------
Une transaction peut être :
    - Un transfert d'argent:
        De Instapay à (Instapay, Mobile Money)
    - Une Reception d'argent (rechargement, depot)
        D'un Inspay, Mobile Money

*/*






# INSCRIPTION DE L'UTILISATEUR
-------------------------------
 - Lien : (Post) http://164.92.134.116/api/v1/signup/
 - Données :
    {
        "full_name":"fisanaj90",
        "email":"fisanaj906@ploneix.com",
        "password":"fisanaj906@ploneix.com"
    }
 - Reponses :
    Succes
        {
            "result": "Le Code de confirmation à été envoyé à fisanaj906@ploneix.com"
        }
    Echec
        {
            "erreur": "Cette adresse mail est déjà utilisé"
        }


# ACTIVATION DE COMPTE
-----------------------
 Lien : (Post) http://164.92.134.116/api/v1/active_my_account/761535/


# CONNECTION
-----------
 - Lien : (Post) http://164.92.134.116/api/v1/login/token/
 
 - Données :
    {
        "email":"fisanaj906@ploneix.com",
        "password":"fisanaj906@ploneix.com"
    }
 - Réponses :

    Succes
        {
            "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY2MzY4NDE0MywianRpIjoiMDY4NTBkMjBhNDY3NDZkMDlkMWY5ZTFhNDdlNzk1NGIiLCJ1c2VyX2lkIjozMH0.CnJaA92riduXP_-KrSgVDWgolHqsjJo6m-rZWWt5kZQ",
            "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjYzNjI3NzQzLCJqdGkiOiJkNGQ4YjkzMmU2ZTE0ZjQ4YmY0NGVhNGQ2OTA0MTE3NCIsInVzZXJfaWQiOjMwfQ.jG3yrv5_ik1HysiA3ovguIfT7UnwOcgqiOrN0sazdJ4"
        }
    
    Echec
        {
            "detail": "Aucun compte actif n'a été trouvé avec les identifiants fournis"
        }




# OBTENIR LES INFORMATIONS DE L'UTILISATEUR
-------------------------------------------
 - Lien : (Get) http://164.92.134.116/api/v1/users/
 
 - Données :
    Token d'accès

 - Reponses :
    Success
        {
            "full_name": "fisanaj90",
            "email": "fisanaj906@ploneix.com",
            "phone_number": null,
            "status": "client",
            "double_authentication": false
        }
    Echec  (Token invalide)
        {
            "detail": "Le type de jeton fourni n'est pas valide",
            "code": "token_not_valid",
            "messages": [{
                "token_class": "AccessToken",
                "token_type": "access",
                "message": "Le jeton est invalide ou expiré"
            }]
        }


# ACTIVER LA DOUBLE AUTHENTIFICATION
------------------------------------

 - Lien : (patch) http://164.92.134.116/api/v1/users/security/?double_authentication=1
 - Données :
    Token d'accès
    {
        "double_authentication" : true
    }
 - Réponses :
    Succès
        {
            "resposne": "",
            "double_authentication": "Activate"
        }
    Echec
        {
            "erreur": "Accès non autorisé"
        }
    
# DESACTIVER LA DOUBLE AUTHENTIFICATION
---------------------------------------

 - Lien : (patch) http://164.92.134.116/api/v1/users/security/?double_authentication=0
 - Données :
    Token d'accès
    {
        "double_authentication" : true
    }
 - Réponses :
    Succès
        {
            "resposne": "",
            "double_authentication": "Activate"
        }
    Echec
        {
            "erreur": "Accès non autorisé"
        }
    



# DEMANDER UN CODE POUR LA DOUBLE AUTHENTIFICAION

 - Lien : (Get) http://164.92.134.116/api/v1/login/second_authentication/
 - Données :
    Token d'accès
 - Réponses :
    Succès
        {
            "success": true
        }
    
    Echec
        Erreur de endpoints
        Erreur de token


# PROCEDER A LA SECONDE AUTHENTIFICATION
----------------------------------------
 - Lien : (Post) http://164.92.134.116/api/v1/login/second_authentication/

- Données :
    Token d'accès
    {
        "second_authentication_code":"25092433"
    }

- Réponses:
    Succès
        {
            "second_authentication_code":"25492433"
        }
    Echec
        Peut importe le code d'authentification la requetes reussie


# ACTIVATION DE LA PROTECTION DU COMPTE

 - Lien : (Post) http://164.92.134.116/api/v1/users/security/?account_protection=1

- Données :
    Token d'accès
    {
        "account_protection_code":"1234"
    }

- Réponses:
    Succès
        {
          "response":""
          "account_protection_activation":"Active"
        }
    Echec
        Ereur endpoint
        Erreur token



# CONSULTATION DU SOLDE
-----------------------

 - Lien : (Get) http://164.92.134.116/api/v1/users/accounts/

- Données :
    Token d'accès


- Réponses:
    Succès
      {
        "status": true,
        "amount": 10988,
        "date_created":"2022-09-20",
        "account_protection":false,
        "provider":1
      }
    Echec
        Ereur endpoint
        Erreur token



# ENVOI D'ARGENT (INSTANTANE/PPROGRAMME) SANS PROTECTION DU COMPTE

  Lien : (Post) http://164.92.134.116/api/v1/users/transactions/

  Données : 
    Token d'accès
    {
      "receiver":"user@mail.com",
      "amount":"500950",
      "date":"2022-09-20"
    }

  Réponses :
    {
      "success":"Transactions reussie"
    }

# ENVOI D'ARGENT (INSTANTANE/PPROGRAMME) AVEC PROTECTION DU COMPTE

  Lien : (Post) http://164.92.134.116/api/v1/users/transactions/

  Données :
    Token d'accès 
    {
      "receiver":"user@mail.com",
      "amount":"500950",
      "date":"2022-09-20",
      "account_protection_code":"1234"
    }

  Réponses :
    {
      "success":"Transactions reussie"
    }


# AFFICHER LA LISTE DES TRANSACTIONS

  Lien : (Get) http://164.92.134.116/api/v1/users/transactions/

  Données :
    Token d'accès 

  Reponses:
    "sender":[
      {
        "id": 1,
        "amount": 30500,
        "datetime_transfer":"2022-09-20 11:23:30",
        "status": true,
        "stats":"1",
        "sender": 28,
        "recipient": 14
      },
      {
        "id": 2,
        "amount": 30500,
        "datetime_transfer":"2022-09-20 11:23:30",
        "status": true,
        "stats":"1",
        "sender": 28,
        "recipient": 14
      }
      
    ]

    "recipient": [{
        "id": 4,
        "amount": 1010.0,
        "datetime_transfer": "2022-09-21T00:00:00Z",
        "status": true,
        "state": "1",
        "sender": 34,
        "recipient": 24
    }]

# REQUETE DE PAIEMENT
---------------------

 - Lien : (Post) http://164.92.134.116/api/v1/users/payment_request/

- Données :
    Token d'accès
    {
      "receiver": "user@mail.com",
      "amount": 10988,
      "reason":"Votre participation pour la fête des jeunes"
    }

- Réponses:
    Succès
      {
        "status": true,
        "amount": 10988,
        "date_created":"2022-09-20",
        "account_protection":false,
        "provider":1
      }
    Echec
        Ereur endpoint
        Erreur token




# ERREUR ENDPOINTS
-------------------

<!doctype html>
<html lang="en">

<head>
    <title>Not Found</title>
</head>

<body>
    <h1>Not Found</h1>
    <p>The requested resource was not found on this server.</p>
</body>












- Form form() {
    return Form(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: TextFormField(
            onChanged: ((value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }),
            onSaved: ((value) {}),
            decoration: const InputDecoration(hintText: "0"),

            ///style: Theme.of(context).textTheme.headline6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: TextFormField(
            onChanged: ((value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }),
            onSaved: ((value) {}),
            decoration: const InputDecoration(hintText: "0"),

            ///style: Theme.of(context).textTheme.headline6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: TextFormField(
            onChanged: ((value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }),
            onSaved: ((value) {}),
            decoration: const InputDecoration(hintText: "0"),

            ///style: Theme.of(context).textTheme.headline6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: TextFormField(
            onChanged: ((value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }),
            onSaved: ((value) {}),
            decoration: const InputDecoration(hintText: "0"),

            ///style: Theme.of(context).textTheme.headline6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: TextFormField(
            onChanged: ((value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }),
            onSaved: ((value) {}),
            decoration: const InputDecoration(hintText: "0"),

            ///style: Theme.of(context).textTheme.headline6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: TextFormField(
            onChanged: ((value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }),
            onSaved: ((value) {}),
            decoration: const InputDecoration(hintText: "0"),

            ///style: Theme.of(context).textTheme.headline6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
      ],
    ));
  }





 {"refresh":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY2MzcwNTY0MiwianRpIjoiYzNmODAwMzI1ZGQ0NGFkYzk2NjA5Yzc0MjdkNDNiMWIiLCJ1c2VyX2lkIjoyNH0.a0efka1ut9TZk5pSfbqJi1PRH-xr47b-kaj15oD1n1c","access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjYzNjQ5MjQyLCJqdGkiOiJiYTFhMGQwNTM1NGU0Mjk4YTNjMTJkNzNlMWQ4N2Y0ZCIsInVzZXJfaWQiOjI0fQ.fu1plf1eJV92o3uT5Y4b_V0XooEK7kBz5gkyoA_SZgw"}