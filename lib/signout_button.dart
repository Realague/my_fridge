import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/authentication_service.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      tooltip: 'Signout',
      onPressed: () {
        context.read<AuthenticationService>().signOut();
      },
    );
  }
}
