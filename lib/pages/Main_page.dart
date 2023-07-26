import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:vendor/pages/Product_page.dart';
import 'package:vendor/pages/homepage.dart';
import 'package:vendor/pages/Oder_page.dart';
import 'package:vendor/pages/person_page.dart';
import 'package:vendor/provider/controller/main_screenProvider.dart';
import 'package:vendor/share/bottomNaviWidget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pageList = const [
    Homepage(),
    ProductPage(),
    OderPage(),
    PersonPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<MainscreenNotifier>(
      builder: (context, mainscreenNotifier, child) {
        return Scaffold(
          body: pageList[mainscreenNotifier.pageIndex],
          bottomNavigationBar: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 0;
                    },
                    icon: Icons.home,
                  ),
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 1;
                    },
                    icon: Icons.add_box,
                  ),
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 2;
                    },
                    icon: Ionicons.cart_outline,
                  ),
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 3;
                    },
                    icon: Icons.person,
                  ),
                ],
              ),
            ),
          )),
        );
      },
    );
  }
}
