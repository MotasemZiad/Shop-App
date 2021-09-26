import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Loading...',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 6.0,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
