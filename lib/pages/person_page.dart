import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/Status_oder_page.dart';
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
  String vendorname = "";
  String vendoremail = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingVendorData();
  }

  gettingVendorData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        vendoremail = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        vendorname = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Text(
            'Profile Person ',
            style: Appstyle(Colors.green, 30, FontWeight.bold),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      text: vendorname,
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
                      text: vendoremail,
                      style: TextStyle(
                        color: Colors.red, // Thay đổi màu tùy ý ở đây
                        fontSize: 20, // Điều chỉnh kích thước tùy ý
                        fontWeight: FontWeight.w400, // Điều chỉnh độ đậm tùy ý
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
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
            onTap: () {
              nextScreen(context, StatusOder());
            },
            leading: Icon(
              Ionicons.cart_sharp,
              size: 30,
              color: Colors.red,
            ),
            title: Text(
              'Status',
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
                      content: Text(
                        'You are sure you want to logout?',
                        style: Appstyle(Colors.black, 20, FontWeight.bold),
                      ),
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
