// ignore_for_file: use_key_in_widget_constructors, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/constants/strings.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/screens/fakeData/fakeProducts.dart';

import 'package:http/http.dart' as http;

class FakeCategoriesScreen extends StatefulWidget {
  final String? storeId;

  const FakeCategoriesScreen({Key? key, this.storeId}) : super(key: key);

  @override
  State<FakeCategoriesScreen> createState() => _FakeCategoriesScreenState();
}

class _FakeCategoriesScreenState extends State<FakeCategoriesScreen> {
  CategoriesModel? categoriesModel;
  bool loadingCategories = true;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getStoriesCategories(widget.storeId!);
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
            'Categories',
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
        body: loadingCategories
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(
                      categoriesModel!.storeCategories!.length,
                      (index) {
                        return buildColumn(
                            context,
                            categoriesModel!
                                .storeCategories![index].categoryName,
                            oShopsBaseUrl +
                                "/" +
                                categoriesModel!
                                    .storeCategories![index].categoryImageURL!
                                    .replaceAll("\\", "/")
                                    .replaceAll(" ", "%20")
                                    .toString(),
                            index);
                      },
                    )),
              ));
  }

  Column buildColumn(
      BuildContext context, String? name, String? imageUrl, int? index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FakeProductScreen(
                    storeId: widget.storeId,
                    categoryId: categoriesModel!.storeCategories![index!].sId
                        .toString(),
                  ),
                ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              imageUrl!,
              width: 100,
              height: 100,
            ),
          ),
        ),
        Text(name!,
            style: const TextStyle(fontSize: 19),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }

  getStoriesCategories(String storeId) async {
    // await CacheHelper.init();
    // var access_token = CacheHelper.getData(key: 'access_token');
    // var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://oshops-app.herokuapp.com/getStoreCategories/$storeId?page=1&size=1'));

    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      categoriesModel = CategoriesModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));
      setState(() {
        loadingCategories = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
