import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/Page_one.dart';
import 'package:vendor/pages/customer/Product_page.dart';
import 'package:vendor/pages/vendor/add_product_page.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/pages/customer/customer_page.dart';
import 'package:vendor/pages/vendor/homepage.dart';
import 'package:vendor/pages/Main_page.dart';
import 'package:vendor/provider/controller/main_screenProvider.dart';
import 'package:vendor/service/Notifications_firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => MainscreenNotifier())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  String _role = "";

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    final isLoggedIn = await HelperFunctions.getUserLoggedInStatus();
    final role = await HelperFunctions.getUserRoleFromSF();
    if (isLoggedIn == true && role != null) {
      setState(() {
        _isSignedIn = isLoggedIn ?? false;
        _role = role;
      });
    }
  }

  Widget buidPage() {
    if (_isSignedIn) {
      if (_role == "customer") {
        return CustomerPage();
      } else {
        return MainScreen();
      }
    } else {
      return PageOne();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange, scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: buidPage(),
    );
  }
}
