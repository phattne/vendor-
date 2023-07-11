import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/add_product_page.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/pages/homepage.dart';
import 'package:vendor/pages/Main_screen.dart';
import 'package:vendor/provider/controller/main_screenProvider.dart';

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

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange, scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
