import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class product_customer extends StatefulWidget {
  const product_customer({super.key});

  @override
  State<product_customer> createState() => _product_customerState();
}

class _product_customerState extends State<product_customer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Customer',
          style: Appstyle(Colors.white, 30, FontWeight.bold),
        ),
      ),
    );
  }
}
