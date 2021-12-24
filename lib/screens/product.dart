// ignore_for_file: use_key_in_widget_constructors, avoid_print, unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/screens/bottom_navigator_bar.dart';
import 'package:shop_app/screens/product_Details_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:http/http.dart' as http;

import 'card.dart';

class ProductScreen extends StatefulWidget {
  final String? storeId;
  final String? categoryId;
  const ProductScreen({Key? key, this.storeId, this.categoryId})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool filledLove = false;
  ProductModel? productModel;
  bool loadingProducts = true;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getStoriesCategoriesProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white10,
          title: const Text(
            'Products',
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
        body: loadingProducts
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Wrap(
                    children: List.generate(productModel!.allProducts!.length,
                        (index) {
                  return Wrap(children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: buildColumn(
                          context,
                          productModel!.allProducts![index].productName
                              .toString(),
                          productModel!.allProducts![index].productImageURL
                              .toString(),
                          productModel!.allProducts![index].price.toString(),
                          productModel!.allProducts![index].rate.toString(),
                          index,
                          productModel!.allProducts![index].sId.toString()),
                    ),
                  ]);
                })),
              ));
  }

  Widget buildColumn(BuildContext context, String? name, String? imageUrl,
      String? price, String? rate, int index, String? id) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      productName: name!,
                      productImageUrl: imageUrl!,
                      productPrice: price!,
                      productRate: rate!,
                      productId: id!,
                    )));
      },
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.network(
              imageUrl!,
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Text(name!,
                    style: const TextStyle(fontSize: 19),
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                price! + " \$",
                style: const TextStyle(fontSize: 20, color: Colors.blue),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              addToCard(productModel!.allProducts![index].sId.toString());
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }

  getStoriesCategoriesProducts() async {
    // await CacheHelper.init();
    // // ignore: non_constant_identifier_names
    // var access_token = CacheHelper.getData(key: 'access_token');
    // var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            "https://oshops-app.herokuapp.com/productsByStoreAndCategory/${widget.storeId}/${widget.categoryId}?page=1&size=1"));

    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      productModel = ProductModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));

      setState(() {
        loadingProducts = false;
      });
    } else {
      print(response.reasonPhrase);
    }
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
