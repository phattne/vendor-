import 'package:flutter/material.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/share/constants.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Title(color: Colors.black, child: Text("hi ," + "My Name"))
      ]),
      body: Center(
          child: ListTile(
        title: Text(
          "Log Out",
          style: Appstyle(Colors.black, 30, FontWeight.w400),
        ),
        leading: IconButton(
          onPressed: () {
            authService.signOut();
          },
          icon: Icon(Icons.exit_to_app),
        ),
      )),
    );
  }
}
