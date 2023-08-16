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

class OderPage extends StatefulWidget {
  const OderPage({Key? key}) : super(key: key);

  @override
  State<OderPage> createState() => _OderPageState();
}

class _OderPageState extends State<OderPage> {
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
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
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

              visibleOrders = allOrders
                  .where(
                      (doc) => doc['status'] == OrderStatus.pending.toString()

                      // doc['status'] != OrderStatus.confirmed.toString() &&
                      // doc['status'] != OrderStatus.canceled.toString() &&
                      // doc['status'] != OrderStatus.delivering.toString() &&
                      // doc['status'] != OrderStatus.completed.toString()
                      )
                  .toList();

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
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(10),
                          color: Colors.orange[100],
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: width * 0.2,
                                    height: height * 0.1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: height * 0.5,
                                              maxWidth: width * 0.2),
                                          child: Image.network(urloder!)),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Customer: $nameuser",
                                        style: GoogleFonts.roboto(
                                            textStyle: Appstyle(Colors.black,
                                                14, FontWeight.normal)),
                                      ),
                                      Text(
                                        'product name:$productname1',
                                        style: GoogleFonts.roboto(
                                            textStyle: Appstyle(Colors.black,
                                                14, FontWeight.normal)),
                                      ),
                                      Text(
                                        "quantity: $quantity",
                                        style: GoogleFonts.roboto(
                                            textStyle: Appstyle(Colors.blue, 14,
                                                FontWeight.normal)),
                                      ),
                                      Text(
                                        '\$$price',
                                        style: GoogleFonts.roboto(
                                            textStyle: Appstyle(Colors.red, 14,
                                                FontWeight.normal)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue),
                                    onPressed: () {
                                      _confirmOrder(documentSnapshot.id);
                                    },
                                    child: Text('Confirm'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      _cancelOrder(documentSnapshot.id);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            }
            return Center(
              child: Text(
                'No orders yet',
                style: Appstyle(Colors.red, 20, FontWeight.bold),
              ),
            );
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
