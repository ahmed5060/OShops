// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, file_names, avoid_print, unnecessary_string_interpolations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/wishlist_model.dart';
import 'package:shop_app/screens/checkoutEnd.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/constants/toast_constant.dart';

class CheckoutDetails extends StatefulWidget {
  final List<WishList>? wishlistModel;
  final String? storeName;
  final dynamic totalPrice;
  final List<int>? productsAmount;
  const CheckoutDetails(
      {Key? key,
      this.wishlistModel,
      this.storeName,
      this.totalPrice,
      this.productsAmount})
      : super(key: key);

  @override
  State<CheckoutDetails> createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  List<String> productsName = [];
  TextEditingController phonenumberController = TextEditingController();
  List<Map<String, String>> userOrder = [];
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    for (var i = 0; i <= (widget.wishlistModel!.length) - 1; i++) {
      productsName.add(widget.wishlistModel![i].productName.toString());
      userOrder.add({
        "productName": widget.wishlistModel![i].productName.toString(),
        "productQuantity": widget.productsAmount![i].toString(),
        "productPrice": widget.wishlistModel![i].productName.toString()
      });
    }
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
              Navigator.of(context).pop();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.wishlistModel!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Image.network(
                              widget.wishlistModel![index].productImageURL
                                  .toString(),
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              widget.wishlistModel![index].productName
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text(
                              "\$" +
                                  widget.wishlistModel![index].price.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "To : " + widget.storeName.toString(),
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "I'm interested in your products : " +
                        productsName.toString(),
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "I look forward to reply.",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: phonenumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Phone Number';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Please Enter Your Phone Number',
                        labelText: 'Phone Number',
                        alignLabelWithHint: false),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        sendMailToStore("heshamfahmi28@gmail.com",
                            int.parse(phonenumberController.text.toString()));
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Send",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
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
    } else {
      print(response.reasonPhrase);
    }
  }

  sendMailToStore(String mail, int phonenumber) async {
    await CacheHelper.init();
    // ignore: non_constant_identifier_names
    var access_token = CacheHelper.getData(key: 'access_token');
    print(access_token);
    var headers = {
      'Authorization': 'Bearer $access_token',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://oshops-app.herokuapp.com/sendOrder'));
    request.body = json.encode({
      "storeEmail": mail,
      "userOrder": userOrder,
      "totalPrice": widget.totalPrice,
      "phoneNumber": phonenumber
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("saved " + await response.stream.bytesToString());
      ToastConstant.showToast(context, "Sucessfully Sending E-mail");
      for (var i = 0; i < (widget.wishlistModel!.length); i++) {
        removeFromCard(widget.wishlistModel![i].sId.toString());
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutEnd(),
          ));
    } else if (response.statusCode == 400) {
      print(await response.stream.bytesToString());
      ToastConstant.showToast(
          context, "Please add an address before sending an order");
    } else {
      print(response.reasonPhrase);
    }
  }
}
