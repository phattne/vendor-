import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vendor/share/constants.dart';

enum OrderStatus {
  pending,
  confirmed,
  delivering,
  completed,
  canceled,
}

class StatusOder extends StatefulWidget {
  const StatusOder({Key? key}) : super(key: key);

  @override
  State<StatusOder> createState() => _StatusOder();
}

class _StatusOder extends State<StatusOder> {
  CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('order');

  List<DocumentSnapshot> visibleOrders = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
          child: Text(
            'Order',
            style: GoogleFonts.roboto(
                textStyle: Appstyle(Colors.white, 18, FontWeight.bold)),
          ),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.white),
        child: StreamBuilder(
          stream: orderCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (streamSnapshot.hasData) {
              final List<QueryDocumentSnapshot> allOrders =
                  streamSnapshot.data!.docs;

              visibleOrders = allOrders;

              return ListView.builder(
                itemCount: visibleOrders.length,
                itemBuilder: ((context, index) {
                  final DocumentSnapshot documentSnapshot =
                      visibleOrders[index];
                  String nameuser = documentSnapshot['customerName'];
                  String productname1 = documentSnapshot['productName'];
                  String emailcustomer = documentSnapshot['customerEmail'];
                  String price = documentSnapshot['price'].toString();
                  String quantity = documentSnapshot['quantity'].toString();
                  String urloder = documentSnapshot['imageUrl'];
                  String status = documentSnapshot['status'];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            color: Colors.orange[100],
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: height * 0.18,
                                      width: width * 0.18,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(urloder!),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Customer: $nameuser",
                                          style: GoogleFonts.roboto(
                                              textStyle: Appstyle(Colors.black,
                                                  14, FontWeight.bold)),
                                        ),
                                        Text(
                                          'Email: $emailcustomer',
                                          style: GoogleFonts.roboto(
                                              textStyle: Appstyle(Colors.blue,
                                                  14, FontWeight.bold)),
                                        ),
                                        Text(
                                          'product: $productname1',
                                          style: GoogleFonts.roboto(
                                              textStyle: Appstyle(Colors.black,
                                                  14, FontWeight.bold)),
                                        ),
                                        Text(
                                          "SL $quantity",
                                          style: GoogleFonts.roboto(
                                              textStyle: Appstyle(Colors.red,
                                                  12, FontWeight.bold)),
                                        ),
                                        Text(
                                          '\$$price',
                                          style: GoogleFonts.roboto(
                                              textStyle: Appstyle(Colors.red,
                                                  14, FontWeight.bold)),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              ' $status',
                                              style: GoogleFonts.roboto(
                                                  textStyle: Appstyle(
                                                      Colors.red,
                                                      14,
                                                      FontWeight.bold)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            }
            return Text('No orders');
          },
        ),
      ),
    );
  }

  Future<void> _confirmOrder(String orderId) async {
    DocumentSnapshot orderSnapshot = await orderCollection.doc(orderId).get();
    setState(() {
      visibleOrders.remove(orderSnapshot);
    });

    await orderCollection.doc(orderId).update({
      'status': OrderStatus.confirmed.toString(),
    });
  }

  Future<void> _cancelOrder(String orderId) async {
    DocumentSnapshot orderSnapshot = await orderCollection.doc(orderId).get();
    setState(() {
      visibleOrders.remove(orderSnapshot);
    });

    await orderCollection.doc(orderId).update({
      'status': OrderStatus.canceled.toString(),
    });
  }
}
