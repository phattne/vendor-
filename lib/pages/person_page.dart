import 'package:flutter/material.dart';
import 'package:vendor/pages/oders_page.dart';
import 'package:vendor/service/auth_service.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/widgets.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({Key? key}) : super(key: key);

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  AuthService authService = AuthService();
  String userName = "Phát Hữu"; // Replace with the user's actual name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              authService.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                  'assets/images/phat.jpg'), // Replace with the user's profile image
            ),
            SizedBox(height: 20),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Email: nguyenhuuphat@gmail.com", // Replace with the user's email
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle edit profile button press
                // Navigate to an EditPersonPage or show a bottom sheet with editing options
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
