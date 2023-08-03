import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  EditProductScreen({required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String? _imageUrl;
  final picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Lấy thông tin sản phẩm từ Firestore khi trang được tạo
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    try {
      DocumentSnapshot productSnapshot =
          await FirebaseFirestore.instance.collection('products').doc(widget.productId).get();

      // Kiểm tra xem sản phẩm có tồn tại không
      if (productSnapshot.exists) {
        setState(() {
          _nameController.text = productSnapshot['name'];
          _priceController.text = productSnapshot['price'].toString();
          _imageUrl = productSnapshot['imageUrl'];
        });
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error fetching product data: $e');
    }
  }

  Future<void> _updateProduct() async {
    String name = _nameController.text;
    double price = double.tryParse(_priceController.text) ?? 0.0;

    try {
      if (_imageFile != null) {
        // Nếu có chọn ảnh mới, upload ảnh lên Firebase Storage và lấy đường dẫn
        Reference ref = FirebaseStorage.instance.ref().child('product').child('${DateTime.now()}.jpg');
        UploadTask uploadTask = ref.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();

        // Cập nhật thông tin sản phẩm vào Firestore với ảnh mới
        await FirebaseFirestore.instance.collection('product').doc(widget.productId).update({
          'name': name,
          'price': price,
          'imageUrl': imageUrl,
        });
      } else {
        // Nếu không chọn ảnh mới, chỉ cập nhật thông tin sản phẩm
        await FirebaseFirestore.instance.collection('product').doc(widget.productId).update({
          'name': name,
          'price': price,
        });
      }

      // Cập nhật thành công, hãy hiển thị thông báo hoặc thực hiện hành động khác
      print('Product updated successfully');
      Navigator.of(context).pop();
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error updating product: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                // Chọn ảnh từ thư viện
                _pickImageFromGallery();
              },
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      )
                    : (_imageUrl != null
                        ? Image.network(
                            _imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.add_a_photo)),
              ),
            ),
                      SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Chọn ảnh từ máy ảnh
                _pickImageFromCamera();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Take a Photo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Product Price'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Gọi hàm để cập nhật sản phẩm
                _updateProduct();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

