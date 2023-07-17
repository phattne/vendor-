import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/pages/Product_page.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/getmyField.dart';
import 'package:vendor/widgets/widgets.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  String titleAppbar = "Add Product";
  String? imageUrl;
  String? url;
  XFile? imageFile;
  String btupdate = " update";
  String Btreset = " Reset";
  final CollectionReference products =
      FirebaseFirestore.instance.collection('product');
  final ImagePicker picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _soluong = TextEditingController();

  Future<void> selectFile() async {
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = pickedImage;
      });
      String imageUrl = await uploadImageToFirebase(imageFile!);
      setState(() {
        url = imageUrl;
      });
    }
  }

  Future<String> uploadImageToFirebase(XFile imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    await storageRef.putFile(File(imageFile.path));
    String imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            titleAppbar,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                "Add product",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(height: 5),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: url != null
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.network(
                        url!,
                        fit: BoxFit.cover,
                      ))
                  : Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(Icons.add_a_photo),
                      )),
            ),
            SizedBox(height: 5),
            Center(
              child: ElevatedButton(
                onPressed: selectFile,
                child: Text('Choose Image'),
              ),
            ),

            // Text('Image URL: $url'),
            SizedBox(
              height: 10,
            ),
            getMyField(
                hintText: "name Product",
                controller: _nameController,
                textInputType: TextInputType.text),
            SizedBox(
              height: 10,
            ),
            getMyField(
                hintText: "so luong",
                controller: _soluong,
                textInputType: TextInputType.number),
            SizedBox(
              height: 10,
            ),
            getMyField(
                hintText: "price",
                controller: _priceController,
                textInputType: TextInputType.number),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      addCourseDetail(context);
                    },
                    child: Text(
                      btupdate,
                      style: Appstyle(Colors.red, 20, FontWeight.w300),
                    )),
                ElevatedButton(
                    onPressed: () {
                      _nameController.text = "";
                      _priceController.text = "";
                      _soluong.text = "";
                      url = null;
                    },
                    child: Text(
                      Btreset,
                      style: Appstyle(Colors.red, 20, FontWeight.w400),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void Function() getAddetailsCallBack(BuildContext context) {
    return () => addCourseDetail(context);
  }

  void addCourseDetail(BuildContext context) async {
    try {
      String name = _nameController.text.trim();
      double? price = double.tryParse(_priceController.text);
      int? soluong = int.tryParse(_soluong.text);
      if (price != null && url != null) {
        await products.add({
          "name": name,
          "price": price,
          "soluong": soluong,
          "imgeUrl": url,
        });
      } else {
        print("no image && price ");
      }

      print("product details are added successfully ");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProductPage()));
    } on FirebaseException catch (e) {
      print("Eross $e");
    }
  }
}
