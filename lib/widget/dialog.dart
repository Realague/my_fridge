import 'package:flutter/material.dart';

class DialogFullScreen extends StatelessWidget {
  DialogFullScreen({required this.title, required this.child}) : super();

  final String title;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            flex: 9,
            child: Text(title),
          ),
          CloseButton(),
        ],
      ),
      insetPadding: EdgeInsets.all(16.0),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            height: height,
            width: width,
            child: child,
          );
        },
      ),
    );
  }
}
