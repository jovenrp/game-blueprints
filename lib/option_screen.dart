import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen(this.currentColor);

  final int currentColor;

  @override
  _OptionScreen createState() => _OptionScreen();
}

class _OptionScreen extends State<OptionScreen> {

  List<int> snakeColors = [
    0xffffffff,
    0xffb2ff59,
    0xff40c4ff,
    0xffffeb3b,
  ];

  List<int> snakeColorsDup = [
    0xffe040fb,
    0xffff4081,
    0xffff6e40,
    0xff795548,
  ];

  int globalColor;

  List<Widget> buildSnakeColorPalette() {
    List<Widget> snakes = <Widget>[];
    for (int i = 0; i < snakeColors.length; i++) {
      bool isActive = false;

      if (snakeColors[i] == globalColor) {
        isActive = true;
      }

      snakes.add(
          Container(
            child: InkWell(
              onTap: () {
                setSnakeColor(snakeColors[i]);
                setState(() {
                  isActive = true;
                });
              },
              child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: isActive ?
                      Border.all(color: Colors.grey, width: 5) :
                      Border.all(color: Colors.grey, width: 0),
                      color: Color(snakeColors[i]),
                    ),
                  )
              ),
            ),
          )
      );

    }

    return snakes;
  }

  List<Widget> buildSnakeColorPalette2() {
    List<Widget> snakes = <Widget>[];

    for (int i = 0; i < snakeColorsDup.length; i++) {
      bool isActive = false;

      if (snakeColorsDup[i] == globalColor) {
        isActive = true;
      }

      snakes.add(
          Container(
            child: InkWell(
              onTap: () {
                setSnakeColor(snakeColorsDup[i]);
                setState(() {
                  isActive = true;
                });
              },
              child: SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: isActive ?
                      Border.all(color: Colors.grey, width: 5) :
                      Border.all(color: Colors.grey, width: 0),
                      color: Color(snakeColorsDup[i]),
                    ),
                  )
              ),
            ),
          )
      );

    }

    return snakes;
  }

  @override
  void initState() {
    super.initState();

    globalColor = widget.currentColor;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:ListView(
        padding: EdgeInsets.only(top: 100.0),
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Text('Options',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60.0
                    ))
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildSnakeColorPalette()
            ),
          ),

          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildSnakeColorPalette2()
            ),
          ),
        ],
      )
    );
  }



  Future<void> setSnakeColor(int colors) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'snakeColor';
    final value = colors;
    prefs.setInt(key, value);
    globalColor = value;
  }
}