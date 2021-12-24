// ignore_for_file: file_names, unnecessary_string_interpolations, avoid_print

import 'package:flutter/material.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/modules/login/log_in_form.dart';

class FakeProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String productImageUrl;
  final String productPrice;
  final String productRate;
  const FakeProductDetailsScreen({
    Key? key,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    required this.productRate,
  }) : super(key: key);

  @override
  State<FakeProductDetailsScreen> createState() =>
      _FakeProductDetailsScreenState();
}

class _FakeProductDetailsScreenState extends State<FakeProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70)),
              color: g,
            ),
            height: 300,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(widget.productImageUrl),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back_ios))),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.productName,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.productPrice,
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  const Text(
                    'Rate : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.productRate,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('You Must Login First'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen("hhhh"),
                            ),
                          );
                        },
                        child: const Text('Go To Login')),
                  ],
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(15.0),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Add To Card",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
