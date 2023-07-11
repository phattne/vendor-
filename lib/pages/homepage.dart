import 'package:flutter/material.dart';
import 'package:vendor/share/constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: height * 0.2,
              width: width,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.green[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(padding: EdgeInsets.only(left: 50)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price" + " " "đ",
                        style: Appstyle(Colors.white, 20, FontWeight.normal),
                      ),
                      Text(
                        "tiền bán hàng",
                        style: Appstyle(Colors.white, 20, FontWeight.normal),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.money_off_outlined,
                    size: 120,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: height * 0.2,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(padding: EdgeInsets.only(left: 50)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "product ",
                        style: Appstyle(Colors.white, 20, FontWeight.normal),
                      ),
                      Text(
                        "đơn hàng bán ",
                        style: Appstyle(Colors.white, 20, FontWeight.normal),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.pin_rounded,
                    size: 120,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(padding: EdgeInsets.only(left: 50)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Price",
                        style: Appstyle(Colors.white, 20, FontWeight.normal),
                      ),
                      Text(
                        "tiền bán hàng",
                        style: Appstyle(Colors.white, 20, FontWeight.normal),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.money_off_outlined,
                    size: 120,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
