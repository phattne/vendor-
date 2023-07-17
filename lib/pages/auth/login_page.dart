import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/Main_screen.dart';
import 'package:vendor/pages/Product_page.dart';
import 'package:vendor/pages/auth/register_Page.dart';
import 'package:vendor/pages/homepage.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/service/database_service.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fromkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
        ),
        body: SingleChildScrollView(
          child: Form(
              key: fromkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "SALE",
                    style: Appstyle(Colors.orange, 40, FontWeight.bold),
                  ),
                  Text(
                    "login Now",
                    style: Appstyle(Colors.grey, 20, FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset('assets/images/background.jpg'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },

                      // check tha validation
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          )),
                      validator: (val) {
                        if (val!.length < 6) {
                          return "Password must be at least 6 characters";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: () {
                        login();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Register here",
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const RegisterPage());
                            }),
                    ],
                  )),
                ],
              )),
        ));
  }

  login() async {
    if (fromkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          final role = snapshot.docs[0]['role'];
          await HelperFunctions.saveUserRoleSF(role);
          nextScreenReplace(
              context,
              // role == "customer" ? ProductPage() :
              MainScreen());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
