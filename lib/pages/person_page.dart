import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/pages/listCustomer_page.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/widgets.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  AuthService authService = AuthService();
  String LogOut = 'LogOut';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Title(color: Colors.black, child: Text("hi ," + "My Name"))
      ]),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              nextScreen(context, ListCustomer());
            },
            leading: Icon(
              Ionicons.person_circle,
              color: Colors.red,
              size: 30,
            ),
            title: Text(
              'Customer',
              style: Appstyle(Colors.black, 20, FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(LogOut),
                      content: Text('you are sure you want to logout?'),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (route) => false);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.green,
                            )),
                      ],
                    );
                  });
            },
            title: Text(
              LogOut,
              style: Appstyle(Colors.black, 20, FontWeight.bold),
            ),
            leading: Icon(
              Ionicons.exit_outline,
              color: Colors.red,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
