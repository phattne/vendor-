import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class DatabaseService {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final String? uid;
  File? _image;

  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // saving the userdata
  Future savingUserData(String fullName, String email, String role) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "role": role,
      // "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future gettingroleData(String role) async {
    QuerySnapshot snapshot =
        await userCollection.where("role", isEqualTo: role).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  //Storage firebase
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

class OrderService {
  // Hàm đặt hàng
  static void placeOrder(List<Productmedol> items, BuildContext context) async {
    // Lưu thông tin đơn hàng vào Firestore với uid của người đặt hàng
    User? user = FirebaseAuth.instance.currentUser;
    String customerId =
        user?.uid ?? "unknown_user"; // Nếu không có user thì gán "unknown_user"
    CollectionReference orderCollection =
        FirebaseFirestore.instance.collection('order');

    for (var productmodel in items) {
      await orderCollection.add({
        'customerId': customerId,
        'productname':
            productmodel.name, // Thêm id sản phẩm vào model nếu chưa có
        'quantity': productmodel.quantity,
        'price': productmodel.price,
        'status': 'pending', // Trạng thái đơn hàng (đang chờ xử lý)
      });
    }

    // Xóa các sản phẩm trong giỏ hàng sau khi đã đặt hàng
    items.clear();

    // Hiển thị thông báo thành công
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt hàng thành công'),
        content: Text(
            'Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ xử lý đơn hàng của bạn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
