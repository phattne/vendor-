import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  List<String> listImage = [
    'assets/images/Online_Shoping_13.jpg',
    'assets/images/4925599.jpg',
    'assets/images/2835907.jpg'
  ];
  PageController _pageController = PageController(viewportFraction: 0.7);

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
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: listImage.length,
                        itemBuilder: (_, index) => Container(
                              margin: const EdgeInsets.all(10),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: AssetImage(listImage[index]),
                                      fit: BoxFit.cover),
                                  color: Colors.amber),
                            )),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: listImage.length,
                    effect: WormEffect(activeDotColor: Colors.amber),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[400]),
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.amber),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Image.network(
                                        productmedol.imageUrl,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                ],
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
        return Container(
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
