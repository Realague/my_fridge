import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../services/authentication_service.dart';

class SignOutButton extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout),
      tooltip: AppLocalizations.of(context)!.button_sign_out,
      onPressed: () {
        context.read<AuthenticationService>().signOut();
      },
    );
  }
}
