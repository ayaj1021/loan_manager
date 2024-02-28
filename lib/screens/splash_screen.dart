import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/loan_app_logo.png',
          scale: 6,
        ),
        RichText(
          text: const TextSpan(
              text: 'EASY, FAST, AND ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
              children: [
                TextSpan(
                  text: 'TRUSTED',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8EDFEB),
                  ),
                )
              ]),
          // appName,
          // style: AppTheme.headerStyle(),
        ),
      ],
    )));
  }

  void _navigate() {
    Future.delayed(const Duration(seconds: 2), () {
      if (FirebaseAuth.instance.currentUser != null) {
        context.go('/loan_dashboard_screen');
      } else {
        context.go('/register_screen');
      }
    });
  }
}
