import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class OdersPage extends StatefulWidget {
  const OdersPage({super.key});

  @override
  State<OdersPage> createState() => _OdersPageState();
}

class _OdersPageState extends State<OdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            'Oders',
            style: Appstyle(Colors.white, 20, FontWeight.w500),
          ),
          
        ),
      ),
    );
  }
}
