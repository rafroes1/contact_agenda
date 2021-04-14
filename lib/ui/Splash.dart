import 'dart:async';
import 'package:flutter/material.dart';
import 'HomePage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("images/logo.png"), fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Your Little Agenda",
              style: TextStyle(fontSize: 22.0, color: Colors.white),
            ),
            SizedBox(
              height: 30.0,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
              strokeWidth: 3.0,
            ),
          ],
        ),
      ),
    );
  }
}
