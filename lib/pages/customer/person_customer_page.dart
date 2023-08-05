import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/share/constants.dart';

import '../../helper/helper_function.dart';

class PersonCustomerPage extends StatefulWidget {
  const PersonCustomerPage({super.key});

  @override
  State<PersonCustomerPage> createState() => _PersonCustomerPageState();
}

class _PersonCustomerPageState extends State<PersonCustomerPage> {
  
  String username = "";
  String useremail = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettinguserData();
  }

  gettinguserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        useremail = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        username = val!;
      });
    });
  }

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
          Icon(
            Ionicons.person_circle,
            size: 100,
          ),
          Text.rich(
            TextSpan(
              text: " Hi,",
              style: Appstyle(Colors.black, 30, FontWeight.w400),
              children: [
                TextSpan(
                  text: username,
                  style: TextStyle(
                    color: Colors.red, // Thay đổi màu tùy ý ở đây
                    fontSize: 25, // Điều chỉnh kích thước tùy ý
                    fontWeight: FontWeight.w400, // Điều chỉnh độ đậm tùy ý
                  ),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: " email: ",
              style: Appstyle(Colors.black, 30, FontWeight.w400),
              children: [
                TextSpan(
                  text: useremail,
                  style: TextStyle(
                    color: Colors.red, // Thay đổi màu tùy ý ở đây
                    fontSize: 20, // Điều chỉnh kích thước tùy ý
                    fontWeight: FontWeight.w400, // Điều chỉnh độ đậm tùy ý
                  ),
                ),
              ],
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
            leading: Icon(Ionicons.exit_outline),
          )
        ],
      ),
    );
  }
}
