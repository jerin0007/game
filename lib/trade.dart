import 'package:candlesticks/candlesticks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/miner.dart';

import 'types.dart';
import 'package:uuid/uuid.dart';

class SelectAsset extends StatefulWidget {
  const SelectAsset({super.key});

  @override
  State<SelectAsset> createState() => _SelectAssetState();
}

class _SelectAssetState extends State<SelectAsset> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Asset",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  children: <Widget>[
                    for (var gcc in [10, 50, 100, 200])
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => TradePage(value: gcc)))
                              .then((value) {
                                Navigator.pop(context);
                              });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset("assets/${gcc}_footer.png"),
                        ),
                      )
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

class TradePage extends StatefulWidget {
  const TradePage({super.key, required this.value});
  final int value;
  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  List<Map> asks = [];
  List<Map> bids = [];
  List<Candle> candles = [];
  generate() {
    int len = (widget.value.toString().length);
    List<double> _asks = [];
    List<double> _bids = [];
    for (var i = 0; i < 10; i++) {
      _asks.add(random(-5, len == 2 ? 20 : 80).toDouble() + widget.value);
      _bids.add(random(-5, len == 2 ? 20 : 80).toDouble() + widget.value);
    }
    _asks.sort();
    _bids.sort();

    for (var ask in _asks) {
      DateTime now = DateTime.now();
      now = now.add(Duration(days: random(-5, 5)));
      asks.add({"amount": ask, "date": now.toString().split(" ")[0]});
    }

    for (var bid in _bids.reversed) {
      DateTime now = DateTime.now();
      now = now.add(Duration(days: random(-5, 5)));
      bids.add({"amount": bid, "date": now.toString().split(" ")[0]});
    }

    // chart
    DateTime now = DateTime.now();
    now = now.add(Duration(days: -100));
    double last = random(-5, len == 2 ? 20 : 80).toDouble() + widget.value;

    for (var i = 1; i < 100; i++) {
      now = now.add(Duration(days: i));
      double vol = random(-5, len == 2 ? 20 : 80).toDouble() + widget.value;

      candles.add(
        Candle(
          date: now,
          high: vol + random(1, 10),
          low: vol + random(1, 10),
          open: last,
          close: vol,
          volume: vol + random(1, 10),
        ),
      );
      last = vol;
    }

    setState(() {});
  }

  @override
  void initState() {
    generate();

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "current market price",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${candles.first.close}\$",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.value.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      Text("GCC", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      SizedBox(height: 10)
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 280,
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        final data = await FirebaseFirestore.instance
                            .collection('gcc')
                            .where("userId", isEqualTo: userId)
                            .where("type", isEqualTo: "${widget.value}_GCC")
                            .get();
                        if (data.docs.isEmpty) {
                        } else {
                          confirmSell(context, data.docs.first, asks.first["amount"].toString(),
                              bids.first["amount"].toString());
                        }
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Sell",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        // final data = await FirebaseFirestore.instance
                        //     .collection('trades')
                        //     .where('amount', isGreaterThan: 0)
                        //     .where('type', isEqualTo: "${widget.value}_GCC")
                        //     .where('status', isEqualTo: "pending")
                        //     .orderBy('amount')
                        //     .limit(1)
                        //     .get();
                        // if (data.docs.isEmpty) {
                        // } else {
                          confirmBuy(
                              context,
                              Uuid().v4(),
                              "${widget.value}_GCC",
                              asks.first["amount"].toString(),
                              bids.first["amount"].toString());
                        // }
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Buy",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

confirmSell(BuildContext context, QueryDocumentSnapshot gcc, String ask, String bid) async {
  TextEditingController amount = TextEditingController();
  String value = gcc["type"].toString().split("_")[0];
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
                  gcc["type"].toString().replaceAll("_", " "),
                  style: TextStyle(fontSize: 20, color: getColor(value), fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("last ask", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 2),
                          Text(
                            ask,
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("last bid", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 2),
                          Text(
                            bid,
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("price"),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.3)),
                  child: TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        RegExp numReg = RegExp(r'^(-?)(0|([1-9][0-9]*))(\\.[0-9]+)?$');
                        if (numReg.hasMatch(amount.text) && amount.text.isNotEmpty) {
                          removePass(context, gcc, amount.text);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Sell",
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

confirmBuy(BuildContext context, String passId, String type, String ask, String bid) async {
  TextEditingController amount = TextEditingController(text: ask);
  String value = type.split("_")[0];
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
                  type.replaceAll("_", " "),
                  style: TextStyle(fontSize: 20, color: getColor(value), fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("last ask", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 2),
                          Text(
                            ask,
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("last bid", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 2),
                          Text(
                            bid,
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("price"),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green.withOpacity(0.3)),
                  child: TextField(
                    controller: amount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        RegExp numReg = RegExp(r'^[0-9]*[.]?[0-9]+$');
                        if (numReg.hasMatch(amount.text) && amount.text.isNotEmpty) {
                          addPassToWallet(value, id: passId);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.green),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          "Buy",
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
