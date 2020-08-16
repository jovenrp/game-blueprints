import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import 'menu_screen.dart';

class GameScreen extends StatefulWidget {

  const GameScreen(this.currentColor);

  final int currentColor;

  @override
  _GameScreen createState() => _GameScreen();
}

class _GameScreen extends State<GameScreen> {
  int numberOfSquares;
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int currentHighscore = 0;
  int usedColor = 0xffffffff;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(600);
  bool hasBorder = false;
  bool isDead = false;
  bool isPlaying = false;

  double screenWidth;
  double screenHeight;

  void generateNewFood() {
    playLocalAsset();
    food = randomNumber.nextInt(600);
  }

  void playLocalAsset() {
    AudioCache player = new AudioCache();
    const alarmAudioPath = "beep.mp3";
    player.play(alarmAudioPath);
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentColor != 0) {
      usedColor = widget.currentColor;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startGame() async {
    isPlaying = true;
    isDead = false;
    direction = 'down';
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 100);
    Timer.periodic(duration, (timer) {
      updateSnake();
      if (gameOver() || isDead) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
      return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _gameOverDialog(context)
      );
    });
    _save();
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'highscore_key';
    final value = snakePosition.length;

    currentHighscore = prefs.getInt(key) ?? 0;

    if (value > currentHighscore) {
      prefs.setInt(key, value);
    }
  }

  var direction = 'down';
  void updateSnake() {
    if (this.mounted) {
      setState(() {
        if (snakePosition.last == food) {
          generateNewFood();
        } else {
          snakePosition.removeAt(0);
        }

        switch(direction) {
          case 'down':
            if (snakePosition.last + 20 > numberOfSquares) {
              if (hasBorder) {
                isDead = true;
              } else {
                snakePosition.add(snakePosition.last - numberOfSquares);
              }
            } else {
              snakePosition.add(snakePosition.last + 20);
            }
            break;
          case 'up':
            if (snakePosition.last < 20) {
              if (hasBorder) {
                isDead = true;
              } else {
                snakePosition.add(snakePosition.last - 20 + numberOfSquares);
              }
            } else {
              snakePosition.add(snakePosition.last - 20);
            }
            break;
          case 'left':
            if (snakePosition.last % 20 == 0) {
              if (hasBorder) {
                isDead = true;
              } else {
                snakePosition.add(snakePosition.last - 1 + 20);
              }
            } else {
              snakePosition.add(snakePosition.last - 1);
            }
            break;
          case 'right':
            if ((snakePosition.last + 1) % 20 == 0) {
              if (hasBorder) {
                isDead = true;
              } else {
                snakePosition.add(snakePosition.last + 1 - 20);
              }
            } else {
              snakePosition.add(snakePosition.last + 1);
            }
            break;
          default:
        }
      });
    }
  }

  _gameOverDialog(BuildContext context) => Container(
    height: screenHeight / 3,
    width: screenWidth / 2,
    padding: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10.0))
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.sentiment_very_dissatisfied,
                  size: 60,
                ),
              ),

              Container(
                child: Text(
                    'Game Over',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40.0
                    )
                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                    'Score: ${snakePosition.length}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0
                    )
                ),
              )
            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  startGame();
                },
                child: Text(
                  'Play Again',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0
                  ),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: InkWell(
                onTap: () {
                  isDead = true;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
                },
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    numberOfSquares = ((screenHeight.toInt() ~/ 100) * 100);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              onTap: () {
                if (!isPlaying) {
                  startGame();
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        if (index == snakePosition.last) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Color(usedColor),
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      if (index == food) {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Icon(
                              Icons.wb_sunny,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }

                    }
                ),
              ),
            ),
          )
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}