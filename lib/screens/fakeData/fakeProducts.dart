// ignore_for_file: use_key_in_widget_constructors, avoid_print, unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/modules/login/log_in_form.dart';
import 'package:shop_app/screens/fakeData/fakeProductDetails.dart';

import 'package:http/http.dart' as http;

class FakeProductScreen extends StatefulWidget {
  final String? storeId;
  final String? categoryId;
  const FakeProductScreen({Key? key, this.storeId, this.categoryId})
      : super(key: key);

  @override
  State<FakeProductScreen> createState() => _FakeProductScreenState();
}

class _FakeProductScreenState extends State<FakeProductScreen> {
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
              Navigator.of(context).pop();
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
                      ),
                    ),
                  ]);
                })),
              ));
  }

  Widget buildColumn(BuildContext context, String? name, String? imageUrl,
      String? price, String? rate, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FakeProductDetailsScreen(
                      productName: name!,
                      productImageUrl: imageUrl!,
                      productPrice: price!,
                      productRate: rate!,
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
}
