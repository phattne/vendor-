import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class OderPage extends StatefulWidget {
  const OderPage({super.key});

  @override
  State<OderPage> createState() => _OderPageState();
}

class _OderPageState extends State<OderPage> {
  final CollectionReference nguoidung =
      FirebaseFirestore.instance.collection('nguoidung');
  String texttitle = "danh sách khách hàng ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            margin: EdgeInsets.only(top: 30),
            height: 250,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular((20)),
                    topRight: Radius.circular(20))),
            child: Center(
              child: Text(
                texttitle,
                style: Appstyle(Colors.white, 20, FontWeight.bold),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            margin: EdgeInsets.only(top: 200),
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: StreamBuilder(
                stream: nguoidung.snapshots(),
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
                          String sdt = documentSnapshot['sdt'].toString();
                          String address = documentSnapshot['dc'];
                          return SingleChildScrollView(
                            child: Card(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5),
                              color: Colors.blue[300],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: Appstyle(
                                            Colors.black, 20, FontWeight.w600),
                                      ),
                                      Text(
                                        sdt,
                                        style: Appstyle(
                                            Colors.red, 20, FontWeight.bold),
                                      ),
                                      Text(
                                        address,
                                        style: Appstyle(Colors.black, 20,
                                            FontWeight.normal),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            _delete(documentSnapshot.id);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: 30,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                  }
                  return const Center(
                    child: Center(
                      child: Text('no product click add product now '),
                    ),
                  );
                }),
          ),
        )
      ],
    ));
  }

  Future<void> _delete(String productId) async {
    await nguoidung.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
