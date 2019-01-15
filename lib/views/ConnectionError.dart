import 'package:flutter/material.dart';
class ConnectionError extends StatefulWidget {
  @override
  _ConnectionErrorState createState() => _ConnectionErrorState();
}

class _ConnectionErrorState extends State<ConnectionError> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Image(
        image: AssetImage("assets/internet_lost.jpg"),
      ),
    );
  }
}
