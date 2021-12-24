// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/card.dart';
import 'package:shop_app/screens/profile.dart';
import 'package:shop_app/screens/shopping.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;
  List<Widget> bottomsScreens = <Widget>[
    ShoppingScreen(),
    ProfileScreen(),
    CardScreen()
  ];
  void changeBottom(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomsScreens.elementAt(currentIndex),
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(Icons.home_rounded, size: 30),
          Icon(Icons.person_outlined, size: 30),
          Icon(Icons.shopping_cart, size: 30),
        ],
        height: 60,
        onTap: (index) {
          changeBottom(index);
        },
        index: currentIndex,
      ),
    );
  }
}
