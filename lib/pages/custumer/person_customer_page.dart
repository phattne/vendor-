import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/share/constants.dart';

class PersonCustomerPage extends StatefulWidget {
  const PersonCustomerPage({super.key});

  @override
  State<PersonCustomerPage> createState() => _PersonCustomerPageState();
}

class _PersonCustomerPageState extends State<PersonCustomerPage> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    String LogOut = 'LogOut';
    
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
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
            leading: Icon(Ionicons.exit_outline),
          )
        ],
      ),
    );
  }
}
