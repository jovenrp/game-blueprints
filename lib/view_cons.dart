import 'package:flutter/material.dart';

class ViewConstant {
  static SnackBar errorSnackBar(String errorMessage) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(errorMessage), Icon(Icons.error)],
      ),
      backgroundColor: Colors.red,
    );
  }

  static SnackBar successSnackBar(String message) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(message), Icon(Icons.check)],
      ),
      backgroundColor: Colors.green,
    );
  }

  static SnackBar loadingSnackBar(String message) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(message, style: TextStyle(color: Colors.black)),
          Container(
            height: 15,
              width: 15,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  static LinearGradient linearGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: const <Color>[Color(0xff0042C4), Color(0xff0077E4)],
      tileMode: TileMode.repeated,
    );
  }

  static SnackBar dynamicSnackBar(
      {String message, IconData icon, Color color}) {
    return SnackBar(
      duration: const Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(message), Icon(icon)],
      ),
      backgroundColor: color,
    );
  }

  static SnackBar progressSnackBar({String message, Color color}) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(message),
          Container(
              height: 10,
              width: 10,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ))
        ],
      ),
      backgroundColor: color,
    );
  }

  Future<TimeOfDay> timePicker(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }
}
