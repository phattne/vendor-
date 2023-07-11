import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
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
        leading: Icon(Icons.exit_to_app),
      )),
    );
  }
}
