import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader();

  @override
  Widget build(final BuildContext context) {
    return Container(
      child: Center(
        child: //Column(
            //children: [
            CircularProgressIndicator(),
        //Text('Loading...'),
        //],
        //  ),
      ),
    );
  }
}
