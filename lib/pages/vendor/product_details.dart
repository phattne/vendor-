import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Product_details extends StatelessWidget {
  final String imageUrl;
  const Product_details({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.network(imageUrl),
    ));
  }
}
