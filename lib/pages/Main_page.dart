import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:vendor/pages/customer/Product_page.dart';
import 'package:vendor/pages/vendor/homepage.dart';
import 'package:vendor/pages/vendor/Oder_page.dart';
import 'package:vendor/pages/vendor/person_page.dart';
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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
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
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.selectedIndex = 0;
                      mainscreenNotifier.pageIndex = 0;
                    },
                    icon: Icons.home,
                    selected: mainscreenNotifier.selectedIndex == 0,
                  ),
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 1;
                      mainscreenNotifier.selectedIndex = 1;
                    },
                    icon: Icons.add_box,
                    selected: mainscreenNotifier.selectedIndex == 1,
                  ),
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 2;
                      mainscreenNotifier.selectedIndex = 2;
                    },
                    icon: Ionicons.cart_outline,
                    selected: mainscreenNotifier.selectedIndex == 2,
                  ),
                  BottomNaviWidget(
                    onTap: () {
                      mainscreenNotifier.pageIndex = 3;
                      mainscreenNotifier.selectedIndex = 3;
                    },
                    icon: Icons.person,
                    selected: mainscreenNotifier.selectedIndex == 3,
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
