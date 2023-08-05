import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                        Card(
                          margin: const EdgeInsets.all(10),
                          color: Colors.grey[300],
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 180,
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
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Email: $emailcustomer',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '$productname1',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "SL $quantity",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$$price',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            ' $status',
                                            style: Appstyle(Colors.red, 16,
                                                FontWeight.bold),
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
