// ignore_for_file: prefer_const_constructors, unnecessary_new, non_constant_identifier_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/screens/fakeData/fakeProductDetails.dart';
import 'package:shop_app/screens/product_Details_screen.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:http/http.dart' as http;

class FakeSearchScreen extends StatefulWidget {
  const FakeSearchScreen({Key? key}) : super(key: key);

  @override
  _FakeSearchScreenState createState() => _FakeSearchScreenState();
}

class _FakeSearchScreenState extends State<FakeSearchScreen> {
  List<Map<String, dynamic>> products = [];
  TextEditingController textEditingController = new TextEditingController();
  bool loading = false;
  searchItem(String param) async {
    products.clear();
    loading = true;
    products.clear();
    // await CacheHelper.init();
    // var access_token = CacheHelper.getData(key: 'access_token');
    // var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request(
      'GET',
      Uri.parse('https://oshops-app.herokuapp.com/productSearch?search=$param'),
    );

    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var items = json.decode(await response.stream.bytesToString());
      //print(items);
      //ItemsModel model = ItemsModel.fromJson(items);
      print(items["data"]);
      items["data"].forEach((element) {
        products.add(element);
      });
      print(products.length);
      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Find your items",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: textEditingController,
                onChanged: (value) {
                  searchItem(value);
                },
                decoration: InputDecoration(
                  hintText: "Please Write What you want",
                  prefixIcon: GestureDetector(
                      onTap: () async {
                        searchItem(textEditingController.text.toString());
                      },
                      child: Icon(Icons.search)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              loading
                  ? Center(child: CircularProgressIndicator())
                  : products.isEmpty
                      ? Container(
                          margin: EdgeInsets.all(20.0),
                          width: double.infinity,
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "there is no item with this name .... please try again",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FakeProductDetailsScreen(
                                              productName: products[index]
                                                      ["productName"]
                                                  .toString(),
                                              productImageUrl: products[index]
                                                      ["productImageURL"]
                                                  .toString(),
                                              productPrice: products[index]
                                                      ["price"]
                                                  .toString(),
                                              productRate: products[index]
                                                      ["rate"]
                                                  .toString(),
                                            )));
                              },
                              child: Card(
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Image.network(
                                            products[index]["productImageURL"],
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              products[index]["productName"],
                                              style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              products[index]["price"]
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
            ],
          ),
        ),
      ),
    );
  }
}
