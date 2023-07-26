import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/share/constants.dart';

class OderPage extends StatefulWidget {
  const OderPage({super.key});

  @override
  State<OderPage> createState() => _OderPageState();
}

class _OderPageState extends State<OderPage> {
  CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('order');

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height,
                width: width,
                decoration: BoxDecoration(color: Colors.deepOrange),
                child: StreamBuilder(
                    stream: orderCollection.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (streamSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (streamSnapshot.hasData) {
                        return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: ((context, index) {
                              final DocumentSnapshot documentSnapshot =
                                  streamSnapshot.data!.docs[index];

                              String nameuser =
                                  documentSnapshot['customerName'];
                              String productname1 =
                                  documentSnapshot['productName'];
                              String price =
                                  documentSnapshot['price'].toString();
                              String quantity =
                                  documentSnapshot['quantity'].toString();
                              String urloder = documentSnapshot['imageUrl'];
                              return Container(
                                height: height * 0.2,
                                child: Card(
                                  child: SingleChildScrollView(
                                    child: ListTile(
                                      leading: Image.network(urloder),
                                      subtitle: Column(
                                        children: [
                                          Text(productname1),
                                          Text('\$$price'),
                                          Text(quantity)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }));
                      }
                      return Text('no oders');
                    }),
              )
            ],
          ),
        ));
  }

  Future<void> _delete(String productId) async {
    await orderCollection.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
