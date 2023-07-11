// import 'dart:io';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// class UploadImageScreen extends StatefulWidget {
//   const UploadImageScreen({Key? key}) : super(key: key);

//   @override
//   State<UploadImageScreen> createState() => _UploadImageScreenState();
// }

// class _UploadImageScreenState extends State<UploadImageScreen> {
//   bool loading = false;
//   File? _image;
//   final picker = ImagePicker();

  

  

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         getImageGallery();
//       },
//       child: Container(
//         height: 200,
//         width: 200,
//         decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//         child: _image != null
//             ? Image.file(_image!.absolute)
//             : Center(child: Icon(Icons.image)),
            
//       ),
//     );
//   }
  
// }
