import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/pages/custumer/produc_page.dart';
import 'package:vendor/share/constants.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Productmedol> items = [];
  int _selectedPageIndex = 0;

  Widget _buildPage() {
    switch (_selectedPageIndex) {
      case 0:
        return _ProductPage(
          onItemSelected: (item) {
            setState(() {
              // items = [...items, items];
            });
          },
        );
      case 1:
        return _CartPage(items);
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          _selectedPageIndex = index;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.abc), label: "products"),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: "selected ${items.length}",
          ),
        ],
      ),
    );
  }
}

class _CartPage extends StatelessWidget {
  const _CartPage(this.items);
  final List<Productmedol> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        Productmedol productmedol = items[index];
        return ListTile(
          leading: Image.network(productmedol.imageUrl),
          title: Text(productmedol.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: \$${productmedol.price.toStringAsFixed(2)}'),
              Text('soluong: ${productmedol.soluong}'),
            ],
          ),
        );
      },
    );
  }
}

class _ProductPage extends StatelessWidget {
  _ProductPage({super.key, required this.onItemSelected});
  final Function(String) onItemSelected;
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
                name: name,
                price: price,
                imageUrl: imageUrl,
                soluong: soluong,
              );
            }).toList();
          }

          return ListView(
            children: [
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(productList.length, (index) {
                    Productmedol productmedol = productList[index];
                    return Container(
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
                                  'Price: \$${productmedol.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'soluong: ${productmedol.soluong}',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
 
}
