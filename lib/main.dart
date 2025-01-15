import 'package:aj_chat_node/splash_screen.dart';
import 'package:flutter/material.dart';

String currentlyLoggedInUserSaveKey = 'currentlyLoggedInUserSaveKey';
// String serverBaseUrl = 'http://192.168.29.71:3000';
String serverBaseUrl = 'https://ajchat.ajaijoseph.in';


Map<String, dynamic>? currentlyLoggedInUserDetailsMap;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AJ Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
