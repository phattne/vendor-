import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/helper/helper_function.dart';
import 'package:vendor/pages/add_product_page.dart';
import 'package:vendor/share/constants.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('product');
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  String _role = "";

  void getUserRole() async {
    final role = await HelperFunctions.getUserRoleFromSF() ?? "";
    setState(() {
      _role = role;
    });
  }

  @override
  void initState() {
    getUserRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Center(
            child: Text(
          "Products",
          style: Appstyle(Colors.white, 20, FontWeight.bold),
        )),
      ),
      floatingActionButton: _role == 'customer'
          ? SizedBox.shrink()
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Addproduct()));
              },
              child: Icon(Icons.add),
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
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: _role == "customer"
                                                  ? _update
                                                  : null,
                                              icon: Icon(
                                                Icons.pending,
                                                size: 30,
                                              ),
                                            ),
                                            _role == ""
                                                ? IconButton(
                                                    onPressed: () {
                                                      _delete(
                                                          documentSnapshot.id);
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      size: 30,
                                                    ))
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  _role == 'vendor'
                                      ? ElevatedButton(
                                          onPressed: () {},
                                          child: Text('mua ngay'),
                                        )
                                      : SizedBox.shrink(),
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

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('chose Image')),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (price != null) {
                      await products
                          .doc(documentSnapshot!.id)
                          .update({"name": name, "price": price});
                      _nameController.text = '';
                      _priceController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }
}
