import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class AuthenticationPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),*/
      body:  Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthenticationService>().signInWithGoogle();
          },
          child: Container(
            child: Text("Sign in with google"),
          ),
      ),
      ),
    );
  }
}