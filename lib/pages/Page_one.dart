import 'package:flutter/material.dart';
import 'package:vendor/pages/auth/login_page.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/widgets.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/images/mainscreen.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  margin: EdgeInsets.only(bottom: 80),
                  child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        nextScreen(context, LoginPage());
                      },
                      child: Text(
                        'Get Started',
                        style: Appstyle(Colors.white, 40, FontWeight.bold),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
