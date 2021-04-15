import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  //SomethingWentWrong({Key? key, required this.errorMessage});

  final String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Container(
        color: Colors.white,
        child: Center(
            child: Text(errorMessage, style: TextStyle(fontSize: 14,color: Colors.red))
        ),
      )
    );
  }
}