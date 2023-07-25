import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../share/constants.dart';

class CustomerproDuct extends StatefulWidget {
  CustomerproDuct({super.key, required this.onItemSelected});
  final Function(Productmedol, int) onItemSelected;

  @override
  State<CustomerproDuct> createState() => _CustomerproDuct();
}

class _CustomerproDuct extends State<CustomerproDuct> {
  final CollectionReference productcollection =
      FirebaseFirestore.instance.collection('product');

  @override
  Widget build(BuildContext context) {
    List<Productmedol> productList = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Customer',
          style: Appstyle(Colors.white, 30, FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productcollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Productmedol> productList = [];

          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            productList = querySnapshot.docs.map((doc) {
              String name = doc['name'];
              double price = doc['price'].toDouble();
              String imageUrl = doc['imgeUrl'];
              double soluong = doc['soluong'].toDouble();
              return Productmedol(
                quantity: 1,
                name: name,
                price: price,
                imageUrl: imageUrl,
                soluong: soluong,
              );
            }).toList();
          }

          return SingleChildScrollView(
            child: Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(productList.length, (index) {
                  Productmedol productmedol = productList[index];
                  return GestureDetector(
                    onTap: () => _showBottomSheet(context, productmedol),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white54),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Image.network(
                                productmedol.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productmedol.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '\$${productmedol.price.toStringAsFixed(2)}',
                                  style: Appstyle(
                                    Colors.red,
                                    16,
                                    FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   'soluong: ${productmedol.soluong}',
                                //   style: TextStyle(
                                //     fontSize: 12,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Productmedol productmedol) {
    int quantity = productmedol.quantity;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Trả về widget cho bottom sheet
        return Container(
          // Nội dung bottom sheet
          child: Column(
            children: [
              Text(
                'Chọn số lượng:,',
                style: Appstyle(Colors.black, 20, FontWeight.w300),
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
                      icon: Icon(Icons.remove)),
                  Text(
                    '$quantity',
                    style: Appstyle(Colors.black, 20, FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                      icon: Icon(Icons.add_outlined))
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onItemSelected(productmedol, quantity);
                  Navigator.pop(context);
                },
                child: Text('Thêm vào giỏ hàng'),
              ),
            ],
          ),
        );
      },
    );
  }
}
