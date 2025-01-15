import 'dart:convert';
import 'dart:developer';

import 'package:aj_chat_node/home_screen.dart';
import 'package:aj_chat_node/login.dart';
import 'package:aj_chat_node/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              width: 200,
              height: 200,
            ),
            Text(
              "AJ Chat",
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPreference = await SharedPreferences.getInstance();
    final userLoggedIn =
        sharedPreference.getString(currentlyLoggedInUserSaveKey);
    if (userLoggedIn == null) {
      gotoLogin();
    } else {
      log(userLoggedIn.toString());
      currentlyLoggedInUserDetailsMap = jsonDecode(userLoggedIn);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}
