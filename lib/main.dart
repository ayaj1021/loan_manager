import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/config/router.dart';
import 'package:loan_manager/firebase_options.dart';
import 'package:loan_manager/provider/authentication/auth_provider.dart';
import 'package:loan_manager/provider/bottom_nav_selection_provider/bottom_nav_selection_provider.dart';
import 'package:loan_manager/provider/firebase_chat_provider/firebase_chat_provider.dart';
import 'package:loan_manager/provider/loan/loan_provider.dart';
import 'package:loan_manager/provider/obscure_provider/obscure_text.dart';
import 'package:loan_manager/provider/theme_provider.dart';
import 'package:loan_manager/styles/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    // appleProvider: AppleProvider.appAttest,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthenticationProviderImpl()),
    ChangeNotifierProvider(create: (context) => LoanProviderImpl()),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider(create: (context) => ObscureTextProvider()),
    ChangeNotifierProvider(create: (context) => BottomNavSelectionProvider()),
    ChangeNotifierProvider(create: (context) => FirebaseChatProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();

  Future<void> getCurrentTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.themePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: Styles.themeData(themeProvider.getDarkTheme, context),
        // Provider.of<ThemeProvider>(context).themeData,

        // ThemeData(
        //     scaffoldBackgroundColor: whiteColor,
        //     primaryColor: primaryColor,
        //     appBarTheme: const AppBarTheme(
        //       centerTitle: true,
        //       scrolledUnderElevation: 0,
        //       backgroundColor: Colors.transparent,
        //     )),
      );
    });
  }
}
