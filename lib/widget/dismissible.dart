import 'package:flutter/material.dart';

class DismissibleBothWay extends StatelessWidget {
  DismissibleBothWay({required this.key, required this.child, this.onDismissed, this.confirmDismiss});

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
            Text(
              "Edit",
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
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              width: 15,
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
