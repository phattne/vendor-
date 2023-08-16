import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/pages/Main_page.dart';
import 'package:vendor/pages/vendor/Product_page.dart';
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
  final CollectionReference productcollection =
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
        backgroundColor: Colors.orange,
        leading: IconButton(
            onPressed: () {
              nextScreen(context, ProductPage());
            },
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 30,
            )),
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
            SizedBox(height: 18),

            SizedBox(height: 8),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.2,
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
            SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: selectFile,
                child: Text(
                  'Choose Image',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            // Text('Image URL: $url'),
            SizedBox(
              height: 8,
            ),
            getMyField(
                hintText: "name Product",
                controller: _nameController,
                textInputType: TextInputType.text),
            SizedBox(
              height: 8,
            ),
            getMyField(
                hintText: "so luong",
                controller: _soluong,
                textInputType: TextInputType.number),
            SizedBox(
              height: 8,
            ),
            getMyField(
                hintText: "price",
                controller: _priceController,
                textInputType: TextInputType.number),
            SizedBox(
              height: 32,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        if (url != null && _nameController != null) {
                          addCourseDetail(context);
                        } else {}
                      },
                      child: Text(
                        btupdate,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  height: 40,
                  width: 120,
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _nameController.text = "";
                        _priceController.text = "";
                        _soluong.text = "";
                       
                      },
                      child: Text(
                        Btreset,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      )),
                ),
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
        await productcollection.add({
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
