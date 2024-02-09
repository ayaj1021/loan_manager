import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_manager/config/constants.dart';
import 'package:loan_manager/styles/themes.dart';

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
        const Icon(Icons.money, size: 120),
        Text(
          appName,
          style: AppTheme.headerStyle(),
        ),
      ],
    )));
  }

  void _navigate() {
    Future.delayed(const Duration(seconds: 3), () {
     if(FirebaseAuth.instance.currentUser != null){
       context.go('/loan_dashboard_screen');
     }else{
      context.go('/register_screen');
     }
    });
  }
}
