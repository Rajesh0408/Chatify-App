import 'package:chatify/pages/SplashPage.dart';
import 'package:chatify/pages/homePage.dart';
import 'package:chatify/services/navigationService.dart';
import 'package:flutter/material.dart';

//pages
import '../pages/LoginPage.dart';
import '../pages/registerPage.dart';

//providers
import 'providers/authenticationProvider.dart';

//packages
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(

    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(const MainApp());
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Chatify",
        theme: ThemeData(
          backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromRGBO(30, 29, 37, 1.0)),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/home' : (BuildContext context) => const HomePage(),
          '/register' : (BuildContext context) => const RegisterPage(),
       },
      ),
    );
  }
}
