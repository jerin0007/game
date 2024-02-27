import 'dart:async';
import 'dart:convert';
// import 'dart:html';
// import 'dart:math';

// import 'package:flame/components.dart';
import 'package:flame/game.dart';
// import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sensors_plus/sensors_plus.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;

import 'types.dart';
import 'game.dart';
// import 'package:flame/game.dart';
// import 'package:flame/components.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    generate();
    fetchCandles().then((value) {
      setState(() {
        candles = value;
      });
    });
    super.initState();
  }

  List<Map> asks = [];
  List<Map> bids = [];
  List<Candle> candles = [];

  generate() {
    for (var i = 0; i < 10; i++) {
      DateTime now = DateTime.now();
      now = now.add(Duration(days: random(-5, 5)));
      asks.add({"amount": random(90, 120), "date": now.toString().split(" ")[0]});
    }
    for (var i = 0; i < 10; i++) {
      DateTime now = DateTime.now();
      now = now.add(Duration(days: random(-5, 5)));
      bids.add({"amount": random(90, 120), "date": now.toString().split(" ")[0]});
    }
    // for (var ask in asks) {
    // candles.add(Candle(
    //     date: DateTime.now(),
    //     open: ask['amount'] * 1.0,
    //     high: ask['amount'] * 2.0,
    //     low: ask['amount'] * 0.2,
    //     close: ask['amount'] * 0.5,
    //     volume: 0));
    candles.add(Candle(date: DateTime.now(), open: 1780.36, high: 1873.93, low: 1755.34, close: 1848.56, volume: 0));
    // }

    asks.sort((a, b) {
      a["amount"].compareTo(b["amount"]);
      // if ( < b["amount"]) {
      //   a = b;
      // }
      return 0;
    });
    setState(() {});
  }

  Future<List<Candle>> fetchCandles() async {
    // var client = http.Client();

    final uri = Uri.parse("https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1h");
    final res = await http.get(uri);
    return (jsonDecode(res.body) as List<dynamic>).map((e) => Candle.fromJson(e)).toList().reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double tw = width / 24;
    Window.width = MediaQuery.of(context).size.width;
    Window.height = MediaQuery.of(context).size.height;
    Window.tileWidth = Window.width / 24;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "current market price",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                "100\$",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: Window.width,
                height: 250,
                child: Candlesticks(
                  candles: candles,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ask", style: TextStyle(fontSize: 18)),
                        Expanded(
                          child: ListView(
                            children: [
                              for (var ask in asks)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("${ask["amount"]} \$",
                                              style: TextStyle(fontSize: 16, color: Colors.red))),
                                      Expanded(flex: 3, child: Text(ask["date"], style: TextStyle(fontSize: 16))),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("bid", style: TextStyle(fontSize: 18)),
                        Expanded(
                          child: ListView(
                            children: [
                              for (var bid in bids)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("${bid["amount"]} \$",
                                              style: TextStyle(fontSize: 16, color: Colors.green))),
                                      Expanded(flex: 3, child: Text(bid["date"], style: TextStyle(fontSize: 16))),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              // Text("price"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Sell",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Buy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
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

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GameWidget(
        game: MyGame(),
      ),
    );
    ;
  }
}
