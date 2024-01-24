import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_options.dart';
import '../services/databaseService.dart';
import '../services/mediaService.dart';
import '../services/navigationService.dart';
import '../services/cloudStorageService.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;

  const SplashPage({
    required Key key,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1))
        .then((_) => _setup().then((_) => widget.onInitializationComplete()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chatify",
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0)),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/logo.png'))),
          ),
        ),
      ),
    );
  }
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
  ? await Firebase.initializeApp(
    //name: 'chatify-app-udemy',
    options: const FirebaseOptions(
        apiKey: 'AIzaSyD_vAEz14HNxGM_jdeMZAD_NUhGcW-cWzM',
        appId: '1:783241783603:android:a8f4f0979ce08f603ef646',
        messagingSenderId: '783241783603',
        projectId: 'chatify-app-udemy',
        storageBucket: 'chatify-app-udemy.appspot.com'),

  )
  : null;
  _registerServices();
}

Future<void> _registerServices() async{



  GetIt.instance.registerSingleton<NavigationService>(NavigationService());
  GetIt.instance.registerSingleton<MediaService>(MediaService());
  GetIt.instance.registerSingleton<CloudStorageService>(CloudStorageService());
  GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
}
