import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:vendor/model/product_model.dart';
import 'package:vendor/pages/custumer/person_customer_page.dart';
import 'package:vendor/pages/custumer/product_custumer_page.dart';

import 'package:vendor/share/constants.dart';

import '../../service/database_service.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<Productmedol> items = [];
  int _selectedPageIndex = 0;
  TextEditingController count = TextEditingController();

  Widget _buildPage() {
    switch (_selectedPageIndex) {
      case 0:
        return CustomerproDuct(
          onItemSelected: (Productmedol productmedol, int quantity) {
            setState(() {
              productmedol.quantity = quantity;
              items.add(productmedol);
            });
          },
        );
      case 1:
        return _CartPage(items);
      case 2:
        return PersonCustomerPage();
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        onTap: (index) => setState(() {
          _selectedPageIndex = index;
        }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "products"),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.cart),
            label: "Cart ${items.length}",
          ),
          BottomNavigationBarItem(icon: Icon(Ionicons.person), label: "person")
        ],
      ),
    );
  }
}

class _CartPage extends StatefulWidget {
  const _CartPage(this.items);
  final List<Productmedol> items;

  @override
  State<_CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<_CartPage> {
  CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('order');

  void _placeOrder() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Yêu cầu đăng nhập'),
          content: Text('Bạn cần đăng nhập để đặt hàng.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    String userName = userSnapshot['fullName'];
    String userEmail = userSnapshot['email'];

    for (var productmodel in widget.items) {
      await orderCollection.add({
        'customerName': userName,
        'customerEmail': userEmail,
        'customerId': user.uid,
        'productName': productmodel.name,
        'quantity': productmodel.quantity,
        'price': productmodel.price,
        'imageUrl': productmodel.imageUrl,
        'status': 'OrderStatus.pending',
      });
    }

    // Xóa các sản phẩm trong giỏ hàng sau khi đã đặt hàng
    setState(() {
      widget.items.clear();
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt hàng thành công'),
        content: Text(
            'Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ xử lý đơn hàng của bạn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;
    for (var productmodel in widget.items) {
      total += productmodel.price * productmodel.quantity;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              Productmedol productmedol = widget.items[index];
              return Column(
                children: [
                  ListTile(
                      leading: Image.network(productmedol.imageUrl),
                      title: Text(productmedol.name),
                      subtitle: Text(
                        '${productmedol.price.toStringAsFixed(2)}',
                        style: Appstyle(Colors.red, 20, FontWeight.bold),
                      ),
                      trailing: Container(
                        width: 170,
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                if (productmedol.quantity > 1) {
                                  setState(() {
                                    productmedol.quantity--;
                                  });
                                }
                              },
                              icon: Icon(Icons.remove)),
                          Text(
                            '${productmedol.quantity}',
                            style: Appstyle(Colors.black, 20, FontWeight.bold),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  productmedol.quantity++;
                                });
                              },
                              icon: Icon(Icons.add_rounded)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.items.removeAt(index);
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ]),
                      )),
                ],
              );
            },
          ),
        ),
        if (widget.items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300]),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'total:',
                      style: Appstyle(Colors.black, 30, FontWeight.w500),
                    ),
                    Text(
                      '\$${total}',
                      style: Appstyle(Colors.red, 30, FontWeight.bold),
                    )
                  ]),
            ),
          ),
        if (widget.items.isNotEmpty)
          Container(
            width: 200,
            child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.orange),
                ),
                onPressed: () {
                  _placeOrder();
                },
                child: Text('Oders')),
          )
      ],
    );
  }
}
