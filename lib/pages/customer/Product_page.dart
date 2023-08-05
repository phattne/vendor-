import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/Main_page.dart';
import 'package:vendor/pages/vendor/add_product_page.dart';
import 'package:vendor/pages/vendor/homepage.dart';
import 'package:vendor/share/constants.dart';
import 'package:vendor/widgets/widgets.dart';

import '../../model/product_model.dart';
import '../../utils/camera.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference productcollection =
      FirebaseFirestore.instance.collection('product');
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityCotroller = TextEditingController();
  String _role = "";
  String? _imageUrl;
  final picker = ImagePicker();
  File? _imageFile;
  List<String> listImage = [
    
  ];

  void getUserRole() async {
    final role = await HelperFunctions.getUserRoleFromSF() ?? "";
    setState(() {
      _role = role;
    });
  }

  @override
  void initState() {
    getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.chevron_left_outlined,
              size: 30,
            )),
        title: Center(
            child: Text(
          "Products",
          style: Appstyle(Colors.white, 20, FontWeight.bold),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addproduct()));
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        color: Colors.grey[400],
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: height * 0.27,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Image.asset('assets/images/4925599.jpg',
                  fit: BoxFit.fitWidth),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Row(
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 30,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'list of products',
                    style: Appstyle(Colors.black, 20, FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: productcollection.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (streamSnapshot.hasData) {
                      return ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];

                            String name = documentSnapshot['name'];
                            String price = documentSnapshot['price'].toString();
                            String url = documentSnapshot['imgeUrl'];
                            String soluong =
                                documentSnapshot['soluong'].toString();
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(url!),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: Appstyle(Colors.black, 20,
                                                  FontWeight.w600),
                                            ),
                                            Text(
                                              "SL $soluong",
                                              style: Appstyle(Colors.blue, 12,
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              '\$$price',
                                              style: Appstyle(Colors.red, 20,
                                                  FontWeight.normal),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  _update(documentSnapshot);
                                                },
                                                icon: Icon(Icons.pending)),
                                            IconButton(
                                                onPressed: () {
                                                  _delete(documentSnapshot.id);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }));
                    }
                    return Container(
                      child: Center(
                          child: Row(
                        children: [
                          Image.asset('assets/sad.png'),
                          Text('Click add product now')
                        ],
                      )),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    print('DocumentSnapshot: $documentSnapshot');

    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
      _quantityCotroller.text = documentSnapshot['soluong'].toString();
      _imageUrl = documentSnapshot['imgeUrl'];
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await _pickImageFromGallery();
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    height: 100,
                    width: 100,
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : Icon(Icons.add_a_photo_outlined),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _pickImageFromGallery();
                  },
                  child: Text('Choose Image'),
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                ),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _quantityCotroller,
                decoration: InputDecoration(
                  labelText: 'Product Quantity',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Center(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                onPressed: () async {
                  final String name = _nameController.text;
                  final double? price = double.tryParse(_priceController.text);
                  final double? quantity =
                      double.tryParse(_quantityCotroller.text);

                  String? updateImageUrl;
                  if (_imageFile != null) {
                    final imageUrl = await _uploadImageToStorage(_imageFile!);
                    if (imageUrl != null) {
                      updateImageUrl = imageUrl;
                    }
                  }
                  if (documentSnapshot != null) {
                    await productcollection.doc(documentSnapshot.id).update({
                      "name": name,
                      "soluong": quantity,
                      "price": price,
                      'imgeUrl': updateImageUrl ?? _imageUrl,
                    });
                  }

                  // Clear the text fields and close the bottom sheet
                  _nameController.text = '';
                  _priceController.text = '';
                  _quantityCotroller.text = '';
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _imageUrl = null;
      }
    });
  }

  Future<String?> _uploadImageToStorage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = '${Random().nextInt(100000)}'; // Tên file ngẫu nhiên
      final uploadTask =
          storageRef.child('product_images/$fileName').putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Xử lý nếu có lỗi trong quá trình upload ảnh
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _delete(String productId) async {
    await productcollection.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
