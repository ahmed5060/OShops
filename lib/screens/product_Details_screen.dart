// ignore_for_file: file_names, unnecessary_string_interpolations, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/screens/card.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final String productImageUrl;
  final String productPrice;
  final String productRate;
  final String productId;
  const ProductDetailsScreen(
      {Key? key,
      required this.productName,
      required this.productImageUrl,
      required this.productPrice,
      required this.productRate,
      required this.productId})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  addToCard(widget.productId);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
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
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CardScreen(),
                      ));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.all(15.0),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Go to Checkout",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  addToCard(String productId) async {
    await CacheHelper.init();
    // ignore: non_constant_identifier_names
    var access_token = CacheHelper.getData(key: 'access_token');
    var headers = {
      'Authorization': 'Bearer $access_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST',
        Uri.parse('https://oshops-app.herokuapp.com/addProductToWishlist'));
    request.body = json.encode({"productId": "$productId"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Result'),
          content: const Text('Successfully Added'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CardScreen(),
                      ));
                },
                child: const Text('Go To Card')),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Result'),
                      content: const Text('Are You Sure!!'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              removeFromCard(productId);
                            },
                            child: const Text('Yes')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'))
                      ],
                    ),
                  );
                },
                child: const Text('Remove'))
          ],
        ),
      );
    } else {
      print(response.reasonPhrase);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Result'),
          content: const Text('Faild ... Please Try Again'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back')),
          ],
        ),
      );
    }
  }

  removeFromCard(String productId) async {
    await CacheHelper.init();
    // ignore: non_constant_identifier_names
    var access_token = CacheHelper.getData(key: 'access_token');

    print(access_token);
    var headers = {
      'Authorization': 'Bearer $access_token',
      'Content-Type': 'application/json; charset=utf-8'
    };
    var request = http.Request(
        'DELETE',
        Uri.parse(
            'https://oshops-app.herokuapp.com/removeProductFromWishlist'));
    request.body = json.encode({"productId": "$productId"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Result'),
          content: const Text('Successfully Deleted ....'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back')),
          ],
        ),
      );
    } else {
      print(response.reasonPhrase);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Result'),
          content: const Text('Faild ... Please Try Again'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back')),
          ],
        ),
      );
    }
  }
}
