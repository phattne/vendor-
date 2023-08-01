import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final CollectionReference productcount =
      FirebaseFirestore.instance.collection('product');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('order');

  Future<Map<String, dynamic>> _calculateTotal() async {
    double totalPrice = 0.0;

    QuerySnapshot orderSnapshot = await orderCollection
        .where('status', isEqualTo: 'OrderStatus.completed')
        .get();

    if (orderSnapshot.docs.isNotEmpty) {
      for (var orderDoc in orderSnapshot.docs) {
        int productQuantity = orderDoc['quantity'];
        double productPrice = orderDoc['price'];

        totalPrice += productPrice * productQuantity;
      }
    }

    return {'totalPrice': totalPrice};
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            'Trang chủ',
            style: Appstyle(Colors.white, 30, FontWeight.bold),
          )),
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _calculateTotal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              double totalPrice = snapshot.data!['totalPrice'];

              return Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   height: height * 0.2,
                  //   width: width,
                  //   margin: EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //     color: Colors.green[300],
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Padding(padding: EdgeInsets.only(left: 50)),
                  //       Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [],
                  //       ),
                  //       Icon(
                  //         Icons.add_shopping_cart,
                  //         size: 120,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: height * 0.2,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price:',
                              style:
                                  Appstyle(Colors.white, 30, FontWeight.bold),
                            ),
                            Text(
                              "${totalPrice.toStringAsFixed(2)} \$",
                              style:
                                  Appstyle(Colors.white, 30, FontWeight.bold),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.pin_rounded,
                          size: 120,
                        )
                      ],
                    ),
                  )
                ],
              );
            }

            return Text("no data");
          },
        ));
  }
}
