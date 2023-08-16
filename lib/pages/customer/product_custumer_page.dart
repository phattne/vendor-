import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vendor/pages/customer/bottom_sheet.dart';

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
  late int quantity;

  @override
  Widget build(BuildContext context) {
    List<Productmedol> productList = [];
    List<Productmedol> cartItems = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'Main Page',
            style: GoogleFonts.roboto(
                textStyle: Appstyle(Colors.white, 28, FontWeight.bold)),
          ),
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
                                  color: Colors.white),
                            )),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: listImage.length,
                    effect: WormEffect(activeDotColor: Colors.orange),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Product',
                          style: Appstyle(Colors.black, 20, FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200]),
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
                          onTap: () {
                            // setState(() {
                            //   quantity = productmedol.quantity;
                            // });
                            _showBottomSheet(context, productmedol);
                          },
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 1),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: Container(
                                        height: 70,
                                        width: 50,
                                        child: Image.network(
                                          productmedol.imageUrl,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productmedol.name,
                                        style: GoogleFonts.roboto(
                                            textStyle: Appstyle(Colors.black,
                                                14, FontWeight.bold)),
                                      ),
                                      Text(
                                        '\$${productmedol.price.toStringAsFixed(2)}',
                                        style: GoogleFonts.roboto(
                                            textStyle: Appstyle(Colors.red, 14,
                                                FontWeight.bold)),
                                      ),
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

  List<Productmedol> cartItems = [];
  void _showBottomSheet(BuildContext context, Productmedol productmedol) async {
    final quantity = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return MyBottomSheet();
      },
    );
    if (quantity != null) {
      productmedol.quantity = quantity;
      print("bottom sheet data >> ${productmedol.quantity}");
      cartItems.add(productmedol);
      widget.onItemSelected(productmedol, quantity);
    }
  }
}
