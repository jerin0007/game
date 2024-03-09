import 'dart:math';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game/types.dart';
import 'package:uuid/uuid.dart';
import 'package:add_to_google_wallet/add_to_google_wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mine() async {
  var _rand = Random();

  if (_rand.nextInt(1000000) == _rand.nextInt(1000000)) {
    addPass(AppConfig.mainContext!, "200");
  } else if ((_rand.nextInt(100000) == _rand.nextInt(100000))) {
    addPass(AppConfig.mainContext!, "100");
  } else if ((_rand.nextInt(10000) == _rand.nextInt(10000))) {
    addPass(AppConfig.mainContext!, "50");
  } else if ((_rand.nextInt(1000) == _rand.nextInt(1000))) {
    addPass(AppConfig.mainContext!, "10");
  }

  return 0;
}

addPass(BuildContext context, String value) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.all(10),
            width: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Congrats!!",
                  style: TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text("you have succesfully mined $value GCC"),
                SizedBox(height: 5),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/${value}_GCC.png",
                      width: 250,
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        addPassToWallet(value);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Claim",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
    },
  );
}

addPassToWallet(String value, {String? id}) async {
  String passId = const Uuid().v4();
  if (id != null) {
    passId = id;
  }
  String passClass = '${value}_GCC';

  final String pass = """
    {
      "iss": "${AppConfig.issuerEmail}",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
        "genericObjects": [
          {
            "id": "${AppConfig.issuerId}.$passId",
            "classId": "${AppConfig.issuerId}.$passClass",
            "genericType": "GENERIC_TYPE_UNSPECIFIED",
            "hexBackgroundColor": "${getColor(value, hex: true)}",
            "logo": {
              "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
              }
            },
            "cardTitle": {
              "defaultValue": {
                "language": "en",
                "value": "Global Citizen Credits"
              }
            },
            "subheader": {
              "defaultValue": {
                "language": "en",
                "value": "Type"
              }
            },
            "header": {
              "defaultValue": {
                "language": "en",
                "value": "$value GCC"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "$passId"
            },
            "heroImage": {
              "sourceUri": {
                "uri": "${getFooter(value)}"
              }
            },
            "textModulesData": [
              {
                "header": "POINTS",
                "body": "1234",
                "id": "points"
              }
            ]
          }
        ]
      }
    }
""";

  AddToGoogleWallet().saveLoyaltyPass(
    pass: pass,
    onError: (_) {},
    onSuccess: () async {
      CollectionReference ref = FirebaseFirestore.instance.collection("gcc");
      await ref.add({"gccId": passId, "userId": userId, "type": "${value}_GCC"});
      // if (id != null) {
      //   final data = await FirebaseFirestore.instance.collection("trades").where("gccId", isEqualTo: id).get();
      //   FirebaseFirestore.instance.collection("trades").doc(data.docs.first.id).delete();
      // }
    },
    onCanceled: () {},
  );
}

removePass(BuildContext context, QueryDocumentSnapshot gcc, String amount) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: EdgeInsets.all(10),
            width: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Warning!!",
                  style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text("before u need to trade your GCC you need to remove it from your wallet"),
                SizedBox(height: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/instruction.png",
                      width: 250,
                    )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String value = gcc["type"].toString().split("_")[0];
                        _removePass(gcc["gccId"], value, amount, gcc);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
    },
  );
}

_removePass(String passId, String value, String amount, QueryDocumentSnapshot gcc) {
  String passClass = '${value}_GCC';

  final String pass = """
    {
      "iss": "${AppConfig.issuerEmail}",
      "aud": "google",
      "typ": "savetowallet",
      "origins": [],
      "payload": {
        "genericObjects": [
          {
            "id": "${AppConfig.issuerId}.$passId",
            "classId": "${AppConfig.issuerId}.$passClass",
            "genericType": "GENERIC_TYPE_UNSPECIFIED",
            "hexBackgroundColor": "${getColor(value)}",
            "logo": {
              "sourceUri": {
                "uri": "https://storage.googleapis.com/wallet-lab-tools-codelab-artifacts-public/pass_google_logo.jpg"
              }
            },
            "cardTitle": {
              "defaultValue": {
                "language": "en",
                "value": "Global Citizen Credits"
              }
            },
            "subheader": {
              "defaultValue": {
                "language": "en",
                "value": "Type"
              }
            },
            "header": {
              "defaultValue": {
                "language": "en",
                "value": "$value GCC"
              }
            },
            "barcode": {
              "type": "QR_CODE",
              "value": "$passId"
            },
            "heroImage": {
              "sourceUri": {
                "uri": "${getFooter(value)}"
              }
            },
            "textModulesData": [
              {
                "header": "POINTS",
                "body": "1234",
                "id": "points"
              }
            ]
          }
        ]
      }
    }
""";

  AddToGoogleWallet().saveLoyaltyPass(
    pass: pass,
    onError: (_) {},
    onSuccess: () async {
      FirebaseFirestore.instance.collection("gcc").doc(gcc.id).delete();
      CollectionReference ref = FirebaseFirestore.instance.collection("trades");

      await ref.add({
        "gccId": passId,
        "userId": userId,
        "amount": double.parse(amount),
        "type": "${value}_GCC",
        "status": "pending",
      });
    },
    onCanceled: () {},
  );
}

getFooter(String value) {
  if (value == "10") {
    return "https://drive.usercontent.google.com/download?id=17g9wcvSW7hHbGhOWBxtCxG_WJtmAjStS&export=view&authuser=0";
  } else if (value == "50") {
    return "https://drive.usercontent.google.com/download?id=1ERCKbkLJ9UL6LV1FpR9XTY07wvck3Ff-&export=view&authuser=0";
  } else if (value == "100") {
    return "https://drive.usercontent.google.com/download?id=1qad9xMWDkyhScsRZSuRFLIt9NB1ZCSie&export=view&authuser=0";
  } else {
    return "https://drive.usercontent.google.com/download?id=11iGyO1s61NPvePxOhWzAsfWw6l9CuNl1&export=view&authuser=0";
  }
  //
}

getColor(String value, {bool? hex}) {
  if (hex == true) {
    if (value == "10") {
      return "#FFDE00";
    } else if (value == "50") {
      return "#004FFF";
    } else if (value == "100") {
      return "#8F0071";
    } else {
      return "#00D800";
    }
  } else {
    if (value == "10") {
      return Color(0xFFFFDE00).darken(0.1);
    } else if (value == "50") {
      return Color(0xFF004FFF);
    } else if (value == "100") {
      return Color(0xFF8F0071);
    } else {
      return Color(0xFF00D800);
    }
  }
}
