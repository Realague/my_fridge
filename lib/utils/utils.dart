import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static final int maxInt = (double.infinity is int) ? double.infinity as int : ~minInt;
  static final int minInt = (double.infinity is int) ? -double.infinity as int : (-1 << 63);

  static final DateTime nullDateTime = DateTime(2050);

  static bool isNumber(String str) {
    return int.tryParse(str) != null;
  }

  static Future<void> showConfirmDialog(
      final BuildContext context, final String content, final Function(String, BuildContext) action, final String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (final BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.confirm),
              onPressed: () {
                action.call(id, context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
