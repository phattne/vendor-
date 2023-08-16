import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/pages/customer/customer_page.dart';

import '../../share/constants.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Text(
            'Chọn số lượng:',
            style: GoogleFonts.roboto(
                textStyle: Appstyle(Colors.black, 28, FontWeight.bold)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                  icon: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.orange),
                      child: Icon(
                        Icons.remove,
                      ))),
              Text(
                '$quantity',
                style: GoogleFonts.roboto(
                    textStyle: Appstyle(Colors.black, 28, FontWeight.bold)),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.orange),
                      child: Icon(Icons.add_outlined)))
            ],
          ),
          SizedBox(
            height: 12,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.pop(context, quantity);
            },
            child: Text(
              'Thêm vào giỏ hàng',
              style: GoogleFonts.roboto(
                  textStyle: Appstyle(Colors.white, 16, FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
