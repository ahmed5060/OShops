// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use, sized_box_for_whitespace, unnecessary_brace_in_string_interps, duplicate_ignore, avoid_print, unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/models/special_store_model.dart';
import 'package:shop_app/models/wishlist_model.dart';
import 'package:shop_app/screens/checkoutDetails.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:http/http.dart' as http;

class CardScreen extends StatefulWidget {
  const CardScreen({Key? key}) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  dynamic price = 0;
  WishlistModel? productModel;
  SpecialStoreModel? storiesModel;
  bool loading = true;
  SlidableController? slidableController;
  List<int> amount = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    userCard();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : productModel!.wishList == null
              ? Center(
                  child: Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Text(
                    "Sorry ... There Is No Products In Your Card",
                    style: TextStyle(color: Colors.red[900], fontSize: 30),
                  ),
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: productModel!.wishList!.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              key: ValueKey(0),
                              endActionPane: ActionPane(
                                motion: ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      setState(() {
                                        removeFromCard(productModel!
                                            .wishList![index].sId
                                            .toString());

                                        loading = true;
                                        userCard();
                                      });
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: buildRow(
                                productModel!.wishList![index].productName,
                                productModel!.wishList![index].price.toString(),
                                productModel!.wishList![index].productImageURL,
                                index,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  const Text(
                                    'TOTAL',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    // ignore: unnecessary_brace_in_string_interps
                                    '\$${price.toString()}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutDetails(
                                          wishlistModel: productModel!.wishList,
                                          storeName:
                                              storiesModel!.store![0].website,
                                          totalPrice: price,
                                          productsAmount: amount,
                                        ),
                                      ));
                                },
                                child: Text(
                                  'Check Out',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget buildRow(String? productName, String? productPrice,
      String? productImage, int index) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: g,
              ),
              height: 100,
              width: 100,
              child: Image.network(productImage!),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName!,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    productPrice!.toString() + '\$',
                    style: TextStyle(fontSize: 19, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      IconButton(
                          color: Colors.blue,
                          onPressed: () {
                            setState(() {
                              amount[index]++;
                              price =
                                  price + productModel!.wishList![index].price;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_circle_up,
                            size: 25,
                          )),
                      Text(
                        amount[index].toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              if (amount[index] > 0) {
                                amount[index]--;
                                price = price -
                                    productModel!.wishList![index].price;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.arrow_circle_down,
                            size: 25,
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  userCard() async {
    await CacheHelper.init();
    // ignore: non_constant_identifier_names
    var access_token = CacheHelper.getData(key: 'access_token');
    var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request(
        'GET', Uri.parse('https://oshops-app.herokuapp.com/getUserWishlist'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      productModel = WishlistModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));

      //print(productModel!.wishList![1].storeId);

      if (productModel!.wishList != null) {
        for (var i = 0; i <= (productModel!.wishList!.length) - 1; i++) {
          price = price + productModel!.wishList![i].price;
          amount.add(1);
          print("variable: " + price.toString());
          print("model: " + productModel!.wishList![i].price.toString());
        }

        getStoreById(productModel!.wishList![0].storeId.toString());

        // print(await response.stream.bytesToString());
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  getStoreById(String storeID) async {
    await CacheHelper.init();
    // ignore: non_constant_identifier_names
    var access_token = CacheHelper.getData(key: 'access_token');
    var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request('GET',
        Uri.parse('https://oshops-app.herokuapp.com/getStoreById/$storeID'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      storiesModel = SpecialStoreModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));
      print("object");
    } else {
      print(response.reasonPhrase);
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
