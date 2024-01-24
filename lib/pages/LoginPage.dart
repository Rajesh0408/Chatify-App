

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../widgets/customButton.dart';
import '../widgets/customInputField.dart';
//providers
import '../providers/authenticationProvider.dart';
import '../services/navigationService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double screenHeight;
  late double screenWidth;

  late AuthenticationProvider auth;
  late NavigationService navigation;

  final loginFormKey = GlobalKey<FormState>();

  String? email;
  String? password;


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Center(
                child: Text(
              'Chatify',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 40,
            ),
            loginForm(),
            const SizedBox(
              height: 60,
            ),
            CustomButton(
              text: 'Login',
              height: screenHeight * 0.065,
              width: screenWidth * 0.65,
              onPressed: () {
                if(loginFormKey.currentState!.validate()){
                  loginFormKey.currentState!.save();
                  auth.loginUsingEmailAndPassword(email!, password!);
                }

              },
            ),
            const SizedBox(
              height: 30,
            ),
            Register(),
          ],
        ),
      ),
    );
  }

  Widget loginForm() {
    return Container(
      height: screenHeight * 0.22,
      child: Form(
        key: loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomInputField(
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              hintText: 'Email',
              obscureText: false,
            ),
            //SizedBox(height: 20,),
            CustomInputField(
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              regEx: r".{8,}",
              hintText: 'Password',
              obscureText: true,
            )
          ],
        ),
      ),
    );
  }

  Widget Register() {
    return GestureDetector(
      onTap: () => navigation.navigateToRoute('/register'),
        child: const Text(
          'Don\'t have an account?',
          style: TextStyle(color: Colors.blue),
        ));
  }
}
