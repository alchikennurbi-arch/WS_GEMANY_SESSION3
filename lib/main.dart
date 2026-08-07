import 'package:flutter/material.dart';
import 'package:session3/pages/profile.dart';
import 'package:session3/screens/login_screeens.dart';
import 'package:session3/widgets/BottomNavBar.dart';
// import 'package:async/async.dart';
// import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // final String? token = prefs.getString("jwt_token");

  // final bool isLogenIn = token != null && token.isNotEmpty;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"profile": (context) => Profile()},
      debugShowCheckedModeBanner: false,
      home: LoginScreeens(),
    );
  }
}
