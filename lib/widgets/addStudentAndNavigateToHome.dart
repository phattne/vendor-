
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:vendor/model/product_model.dart';

// import '../pages/add_product_page.dart';

// void addStudentAndNavigateToHome(Product product, BuildContext context) {
//     //
//     // Reference to firebase
//     final ProductRef = FirebaseFirestore.instance.collection('Product').doc();
//     product.id = ProductRef.id;
//     final data = product.toJson();
//     ProductRef.set(data).whenComplete(() {
//       //
//       // log('shdjfhjks');
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AddproductPage(),
//         ),
//         (route) => false,
//       );
//       //
//     });

//     //
//   }