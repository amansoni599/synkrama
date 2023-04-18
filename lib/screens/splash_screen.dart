import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signin_signup/provider/sign_in_provider.dart';
import 'package:signin_signup/screens/home_screen.dart';
import 'package:signin_signup/screens/login_screen.dart';
import 'package:signin_signup/utils/next__screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // init state
  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();

    // create a timer of 2 seconds
    Timer(const Duration(seconds: 0), (() {
      sp.isSignedIn == false
          ? nextScreenReplace(context, const LoginScreen())
          : nextScreenReplace(context, const HomeScreen());
    }));
  }

  getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
