import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/Main_page.dart';
import 'package:vendor/pages/customer/Product_page.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/pages/customer/customer_page.dart';
import 'package:vendor/pages/vendor/homepage.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fromkey = GlobalKey<FormState>();
  bool _isLoading = false;
  String fullname = "";
  String email = "";
  String password = "";
  bool isCustomer = false;
  bool isVendor = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: fromkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
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
                        labelText: "full name",
                        prefixIcon: Icon(
                          Icons.people,
                          color: Colors.black,
                        )),
                    onChanged: (val) {
                      setState(() {
                        fullname = val;
                      });
                    },
                    // check tha validation
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "Name cannot be empty";
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                      register();
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Thêm dòng này để chỉ định kích thước tối thiểu cho Row

                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          leading: Radio(
                            value: true,
                            groupValue: isCustomer,
                            onChanged: (selected) {
                              setState(() {
                                isCustomer = selected ?? false;
                                isVendor = false; // Clear the vendor selection
                              });
                            },
                          ),
                          title: Text("Customer"),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Radio(
                            value: true,
                            groupValue: isVendor,
                            onChanged: (selected) {
                              setState(() {
                                isVendor = selected ?? false;
                                isCustomer =
                                    false; // Clear the customer selection
                              });
                            },
                          ),
                          title: Text("Vendor"),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Login Now",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            nextScreen(context, const LoginPage());
                          }),
                  ],
                )),
              ],
            )),
      ),
    );
  }

  register() async {
    String role = "";
    if (isCustomer) role = "customer";
    if (isVendor) role = "vendor";

    if (fromkey.currentState!.validate() && isCustomer || isVendor) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
        fullname,
        email,
        password,
        role,
      )
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullname);

          await HelperFunctions.saveUserRoleSF(role);
          nextScreenReplace(
              context, role == "customer" ? CustomerPage() : MainScreen());
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
