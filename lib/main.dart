// coded by: Salis Mazaya Miftah Malik
// 25 - 03 - 2020
// ini akan menjadi kenangan

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' ;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List<Widget> kotak = [];
  List<int> p1_selected = [];
  List<int> p2_selected = [];
  List<dynamic> pattern = [
    [0,1,2],
    [3,4,5],
    [6,7,8],
    [0,3,6],
    [1,4,7],
    [2,5,8],
    [0,4,8],
    [2,4,6],
  ]; 
  bool p1_turn = true;
  bool gameEnd = false;
  bool p1_first = true;
  String info = "Player 1 Turn";
  int p1_score = 0;
  int p2_score = 0;
  double sizeGambar;
  double sizeScreen;


  void setSize(double size) {
    this.sizeGambar = size / 4;
    this.sizeScreen = size;
    for (int i = 0; i < 10; i++) {
      kotak.add(GestureDetector(
          child: Image.asset("images/kotak.png", height: this.sizeGambar),
          onTap: () {pilih(i);},
        )
      );
    }
  }

  void pilih(arg) {
    if (!this.gameEnd){
      setState(() {
        if (this.p1_turn){
          this.p1_turn = false;
          this.p1_selected.add(arg);
          this.kotak[arg] = Image.asset("images/kotak_bulet.png", height: this.sizeGambar);
          this.info = "Player 2 Turn";
        } else {
          this.p1_turn = true;
          this.p2_selected.add(arg);
          this.kotak[arg] = Image.asset("images/kotak_silang.png", height: this.sizeGambar);
          this.info = "Player 1 Turn";
        }
        String winner = who_win();
        if (winner == "Player 1") {
          setState(() {
            this.info = "Winner: Player 1";
            this.p1_score++;
          });
        } else if (winner == "Player 2"){
          setState(() {
            this.info = "Winner: Player 2";
            this.p2_score++;
          });         
        } else if (winner == "Draw"){
          setState(() {
            this.info = "Draw";
          });           
        }
      });
    }
  }

  String who_win() {
    for (var x in this.pattern) {
      if (this.p1_selected.contains(x[0]) && this.p1_selected.contains(x[1]) && this.p1_selected.contains(x[2])) {
        this.gameEnd = true;
        return "Player 1";
      } else if (this.p2_selected.contains(x[0]) && this.p2_selected.contains(x[1]) && this.p2_selected.contains(x[2])){
        this.gameEnd = true;
        return "Player 2";
      }
    }
    if (this.p1_selected.length + this.p2_selected.length == 9) {
      this.gameEnd = true;
      return "Draw";
    }
  }

  void gamelagi () {
    setState(() {
      p1_first = !p1_first;
      p1_turn = p1_first;
      gameEnd = false;
      info = p1_first ? "Player 1 Turn" : "Player 2 Turn";
      p1_selected = [];
      p2_selected = [];
      kotak = [];
      for (int i = 0; i < 10; i++) {
        kotak.add(GestureDetector(
            child: Image.asset("images/kotak.png", height: this.sizeGambar),
            onTap: () {pilih(i);},
          )
        );
      }
    });
  }

  Container sembilanKotak () {
    return Container(
      child: Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[kotak[0], kotak[1], kotak[2]]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[kotak[3], kotak[4], kotak[5]]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[kotak[6], kotak[7], kotak[8]]),
      ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    setSize(MediaQuery.of(context).size.width);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    precacheImage(AssetImage("images/kotak_bulet.png"), context);
    precacheImage(AssetImage("images/kotak_silang.png"), context);
    precacheImage(AssetImage("images/kotak.png"), context);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 80.0),
                  child: Center(
                    child: Column(
                    children: <Widget>[
                      Text("Tictactoe", style: TextStyle(fontSize: this.sizeScreen / 10, color: Colors.red[800], fontWeight: FontWeight.bold)),
                      Container(height: this.sizeScreen / 28),
                      Text(info, style: TextStyle(fontSize: this.sizeScreen / 20)),
                    ]
                  ))
                )
              ]
            )
          ),
          Flexible(
            flex: 3,
            child: sembilanKotak()
          ),
          Flexible(
            flex: 2,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(height: this.sizeScreen / 28),
                  Text("$p1_score : $p2_score", style: TextStyle(fontSize: this.sizeScreen / 20)),
                  Container(height: this.sizeScreen / 43),
                  RaisedButton(child: Text("Play Again"), onPressed: this.gameEnd ? gamelagi : null),
                ]
              )
            )
          ),
        ]
      )
    );
  }
}