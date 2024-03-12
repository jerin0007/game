import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:game/trade.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';

import 'login.dart';
import 'types.dart';
import 'game/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
// if (kIsWeb){
  // runApp(MyApp());
// }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Login(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List credits = [];
  List tradeHistory = [];

  @override
  void initState() {
    getData();

    super.initState();
  }

  getData() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    final data = await FirebaseFirestore.instance.collection('gcc').where("userId", isEqualTo: userId).get();

    credits = data.docs;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppConfig.width = MediaQuery.of(context).size.width;
    AppConfig.height = MediaQuery.of(context).size.height;
    AppConfig.tileWidth = AppConfig.width / 24;
    AppConfig.mainContext = context;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectAsset())).then((_) {
                    getData();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.4)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Trade now",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Buy and sell GCC with builtin trading platform",
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.attach_money_sharp,
                        color: Colors.green,
                      )
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TradePage()));
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              //     decoration:
              //         BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.4)),
              //     child: Row(
              //       children: [
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "View Trades",
              //                 style: TextStyle(fontSize: 15),
              //               ),
              //               SizedBox(height: 2),
              //               Text(
              //                 "See previous trades",
              //                 style: TextStyle(fontSize: 13),
              //               ),
              //             ],
              //           ),
              //         ),
              //         Icon(
              //           Icons.history,
              //           color: Colors.green,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: 15),
              if (credits.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "your credits",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              if (credits.isEmpty)
                Expanded(child: Center(child: SizedBox(width: 200, child: Lottie.asset('assets/play.json'))))
              else
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    children: <Widget>[
                      for (var gcc in credits)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/${gcc["type"]}.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GamePage())).then((_) {
                    getData();
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Play Game",
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

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FlameAudio.bgm.play("bgm.mp3", volume: 0.4);
    } else {
      FlameAudio.bgm.pause();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    if (!FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.play("bgm.mp3", volume: 0.4);
    }

    super.initState();
  }

  playAudio() {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 500) {
      AppConfig.width = 500;
    } else {
      AppConfig.width = MediaQuery.of(context).size.width;
    }
    // AppConfig.width = MediaQuery.of(context).size.width;
    AppConfig.height = MediaQuery.of(context).size.height;
    AppConfig.tileWidth = AppConfig.width / 24;
    AppConfig.mainContext = context;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: AppConfig.width,
                child: GameWidget(
                  game: MyGame(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: (MediaQuery.of(context).size.width - AppConfig.width) / 2,
                height: AppConfig.height,
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: (MediaQuery.of(context).size.width - AppConfig.width) / 2,
                height: AppConfig.height,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
