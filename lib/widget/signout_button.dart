import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/main.dart';
import 'package:my_fridge/model/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: AppLocalizations.of(context)!.button_sign_out,
      onPressed: () {
        context.read<AuthenticationService>().signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
        );
      },
    );
  }
}
