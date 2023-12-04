import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodconnect/Network/SessionManager.dart';
import 'package:foodconnect/Presentation/homepage.dart';
import 'package:foodconnect/Presentation/login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/splash.png')))));
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    String? isLogin = await SharedPref().getToken();

    if (isLogin != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePageWidget(),
          maintainState: false,
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPageWidget(),
          maintainState: false,
        ),
      );
    }
  }
}
