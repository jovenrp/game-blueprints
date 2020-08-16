import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake/option_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:snake/game_screen.dart';
import 'package:snake/view_cons.dart';

class MenuScreen extends StatefulWidget {

  @override
  _MenuScreen createState() => _MenuScreen();

}

class _MenuScreen extends State<MenuScreen> {

  int currentColor;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    readSnakeColor();

    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        body: Container(
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'S N A K E',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 60.0
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 0.0, top: 20.0),
                          child: InkWell(
                            onTap: () {
                              _scaffoldKey.currentState.showSnackBar(ViewConstant.loadingSnackBar('Loading game...'));
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                setState(() {
                                  _scaffoldKey.currentState.hideCurrentSnackBar();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => GameScreen(currentColor)),
                                  );
                                });
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  'Play',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.0
                                  )
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(right: 0.0, top: 20.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OptionScreen(currentColor)),
                              ).then((value) =>
                                  readSnakeColor()
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  'Options',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.0
                                  )
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: InkWell(
                            onTap: (){
                              SystemNavigator.pop();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                  'Exit',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40.0
                                  )
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  )
                ],
              )
          ),
        ),
      ),
    );
  }

  Future<void> readSnakeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'snakeColor';
    final value = prefs.getInt(key) ?? 0;
    currentColor = value;
  }

  Future<bool> exitApp() async {
    SystemNavigator.pop();
    return true;
  }
}