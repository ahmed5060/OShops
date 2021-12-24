// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/screens/bottom_navigator_bar.dart';
import 'package:shop_app/screens/product.dart';

class BrandsScreen extends StatelessWidget {
  List BrandsName = [
    'adidas',
    'Samsung',
    'Noon',
    'Nike',
    'apple',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white10,
        title: const Text(
          'Brand Name',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => BottomNavigationScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  buildColumn(context),
                  const Spacer(),
                  buildColumn(context),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  buildColumn(context),
                  const Spacer(),
                  buildColumn(context),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  buildColumn(context),
                  const Spacer(),
                  buildColumn(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProductScreen()));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: g,
            ),
            height: 180,
            width: 180,
            child: Image.asset('assets/images/w1.png'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('watch',
            style: TextStyle(fontSize: 19),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        const SizedBox(
          height: 10,
        ),
        const Text(
          '300\$',
          style: TextStyle(fontSize: 19, color: Colors.green),
        ),
      ],
    );
  }
}
