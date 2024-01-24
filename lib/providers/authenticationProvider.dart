import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//services
import '../models/chatUser.dart';
import '../services/databaseService.dart';
import '../services/navigationService.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationService navigationService;
  late final DatabaseService databaseService;
  ChatUser? user;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigationService = GetIt.instance.get<NavigationService>();
    databaseService = GetIt.instance.get<DatabaseService>();

    auth.signOut();

    auth.authStateChanges().listen((_user) {
      if (_user != null) {
        databaseService.updateUserLastSeenTime(_user.uid);
        databaseService.getUser(_user.uid).then((snapshot) {
          Map<String, dynamic> userData =
              snapshot.data() as Map<String, dynamic>;
          user = ChatUser.fromJSON(
            {
              "uid": _user.uid,
              "name": userData["name"],
              "email": userData["email"],
              "image": userData["image"],
              "lastActive": userData["last_active"].toDate(),
            },
          );
          navigationService.removeAndNavigateToRoute('/home');
        });
        print(user?.toMap());
      } else {
        navigationService.removeAndNavigateToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(String email, String password) async {
    try {
      auth.signInWithEmailAndPassword(email: email, password: password);
      print(auth.currentUser);
    } on FirebaseAuthException {
      print("Error in logging user into firebase");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException {
      print("Error registering user");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async{
    try{
      await auth.signOut();
    }catch(e){
      print(e);
    }
  }
}
