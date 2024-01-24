//packages
import 'package:chatify/widgets/roundedImage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//services
import '../services/mediaService.dart';
import '../services/databaseService.dart';
import '../services/cloudStorageService.dart';
import '../services/navigationService.dart';

//widgets
import '../widgets/customInputField.dart';
import '../widgets/customButton.dart';

//providers
import '../providers/authenticationProvider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double screenHeight;
  late double screenWidth;

  late AuthenticationProvider auth;
  late DatabaseService db;
  late CloudStorageService cloudStorage;
  late NavigationService navigation;

  String? password;
  String? name;
  String? email;

  PlatformFile? profileImage;

  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance.get<DatabaseService>();
    cloudStorage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationService>();

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WidgetUI();
  }

  Widget WidgetUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
        width: screenWidth * 0.98,
        height: screenHeight * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImageField(),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            registerForm(),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((file) {
          setState(() {
            profileImage = file;
          });
        });
      },
      child: () {
        if (profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: profileImage!,
            size: screenHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
              key: UniqueKey(),
              imagePath:
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Dhanush_at_VIP_2_Success_Meet.jpg/800px-Dhanush_at_VIP_2_Success_Meet.jpg',
              size: screenHeight * 0.15);
        }
      }(),
    );
  }

  Widget registerForm() {
    return Container(
      height: screenHeight * 0.35,
      child: Form(
        key: registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputField(
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Name",
                obscureText: false),
            CustomInputField(
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomInputField(
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
                regEx: r'.{8,}',
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return CustomButton(
      onPressed: () async {
        if (registerFormKey.currentState!.validate() && profileImage != null) {
          registerFormKey.currentState!.save();
          String? uid =
              await auth.registerUserUsingEmailAndPassword(email!, password!);
          String? imageURL = await cloudStorage.saveUserImageToStorage(
              uid!, profileImage!);
          await db.createUser(uid, email!, name!, imageURL!);
          await auth.logout();
          await auth.loginUsingEmailAndPassword(email!, password!);
        }
      },
      text: 'Register',
      height: screenHeight * 0.065,
      width: screenWidth * 0.65,
    );
  }
}
