import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class product_customer extends StatefulWidget {
  const product_customer({super.key});

  @override
  State<product_customer> createState() => _product_customerState();
}

class _product_customerState extends State<product_customer> {
   final CollectionReference products =
      FirebaseFirestore.instance.collection('product');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Customer',
          style: Appstyle(Colors.white, 30, FontWeight.bold),
        ),
      ),
      
      body: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: products.snapshots(),
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

                            String name = documentSnapshot['name'];
                            String price = documentSnapshot['price'].toString();
                            String url = documentSnapshot['imgeUrl'];
                            String soluong =
                                documentSnapshot['soluong'].toString();
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Card(
                                    margin: const EdgeInsets.all(10),
                                    color: Colors.grey[300],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(url!),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: Appstyle(Colors.black, 20,
                                                  FontWeight.w600),
                                            ),
                                            Text(
                                              "SL $soluong",
                                              style: Appstyle(Colors.red, 12,
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              price,
                                              style: Appstyle(Colors.black, 20,
                                                  FontWeight.normal),
                                            )
                                          ],
                                        ),
                                       
                                      ],
                                    ),
                                  ),
                                 
                                ],
                              ),
                            );
                          }));
                    }
                    return const Center(
                      child: Center(
                        child: Text('no product click "add product" now '),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
