import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DismissibleBothWay extends StatelessWidget {
  DismissibleBothWay({required this.key, required this.child, this.onDismissed, this.confirmDismiss}) : super();

  final Key key;

  final Widget child;

  final DismissDirectionCallback? onDismissed;

  final ConfirmDismissCallback? confirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      background: Container(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              AppLocalizations.of(context)!.swipe_to_edit,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              AppLocalizations.of(context)!.swipe_to_delete,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      child: child,
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
    );
  }
}
