import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/main.dart';
import 'package:uuid/uuid.dart';

import 'types.dart';

class Login extends StatefulWidget {
  const Login({super.key, this.signUp = false});

  final bool signUp;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ListView(
                children: [
                  SizedBox(height: 60),
                  Row(
                    children: [
                      SizedBox(width: 2),
                      Image.asset(
                        "assets/images/char.png",
                        width: 20,
                        // height: 20,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Green Pledge",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text(
                    "To get the best of the game, please Log in",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (widget.signUp)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration:
                          BoxDecoration(color: Colors.green.withOpacity(0.35), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.red,
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: Text(
                                "please enter the g-mail id used in google wallet to provide access incase publish access is not granted"),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    "Enter your email",
                    // style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.3)),
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter your password",
                    // style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.3)),
                    child: TextField(
                      controller: password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!widget.signUp)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Dont have account? "),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(builder: (context) => Login(signUp: true)));
                            },
                            child: Text("Sign up", style: TextStyle(color: Colors.green))),
                      ],
                    ),
                ],
              )),
              GestureDetector(
                onTap: () async {
                  if (Firebase.apps.isEmpty) {
                    await Firebase.initializeApp();
                  }
                  final data = await FirebaseFirestore.instance
                      .collection('users')
                      .where("emailId", isEqualTo: email.text)
                      .get();

                  if (data.docs.isNotEmpty) {
                    userId = data.docs.first["userId"];
                    // showSnackBar(context, "Logging in");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                  } else if (widget.signUp) {
                    userId = Uuid().v4();
                    await FirebaseFirestore.instance
                        .collection('users')
                        .add({"userId": Uuid().v4(), "emailId": email.text, "password": password.text});
                  } else {
                    showSnackBar(context, "Email does not exists");
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (widget.signUp) ? "Sign in" : "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
