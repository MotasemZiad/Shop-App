import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shop.png',
            fit: BoxFit.cover,
            width: 120.0,
            height: 120.0,
          ),
          SizedBox(
            height: 4.0,
          ),
          Text('Loading...'),
          Spacer(),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
