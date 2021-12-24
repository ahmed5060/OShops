// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, deprecated_member_use, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shop_app/constants/strings.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/stores_model.dart';
import 'package:shop_app/modules/login/log_in_form.dart';
import 'package:shop_app/modules/signup/sign_up_form.dart';
import 'package:shop_app/screens/fakeData/fakeCategories.dart';
import 'package:shop_app/screens/fakeData/fakeProductDetails.dart';
import 'package:shop_app/screens/fakeData/fakeSearch.dart';
import 'package:http/http.dart' as http;

class FakeHomePage extends StatefulWidget {
  const FakeHomePage({Key? key}) : super(key: key);

  @override
  State<FakeHomePage> createState() => _FakeHomePageState();
}

class _FakeHomePageState extends State<FakeHomePage> {
  bool loading = true;
  bool loadingProducts = true;
  StoriesModel? storiesModel;
  ProductModel? productModel;

  final BannerAd myBanner = BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getAllProducts();
    getAllStories();
    _initGoogleMobileAds();
    myBanner.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildColumn(BuildContext context, screen, url, name, price) {
      return Container(
        margin: EdgeInsets.all(10.0),
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => screen));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  url,
                  height: 100,
                  width: 100,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Text(name,
                  style: TextStyle(fontSize: 19),
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              price + '\$',
              style: TextStyle(fontSize: 19, color: Colors.green),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Oshops",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Flexible(
                          flex: 8,
                          child: Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(29.5),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FakeSearchScreen(),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.search,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: const [
                        Text(
                          'Stores',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 135,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: storiesModel!.allStores!.length,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(right: 20),
                          width: 80,
                          child: Column(
                            children: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FakeCategoriesScreen(
                                          storeId: storiesModel!
                                              .allStores![index].sId,
                                        ),
                                      ));
                                },
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(oShopsBaseUrl +
                                          "/" +
                                          storiesModel!
                                              .allStores![index].storeLogoURL!
                                              .replaceAll("\\", "/")
                                              .toString()),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(storiesModel!.allStores![index].storeName
                                  .toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: AdWidget(ad: myBanner),
                    width: myBanner.size.width.toDouble(),
                    height: myBanner.size.height.toDouble(),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  loadingProducts
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: productModel!.allProducts!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildColumn(
                                    context,
                                    FakeProductDetailsScreen(
                                      productName: productModel!
                                          .allProducts![index].productName
                                          .toString(),
                                      productImageUrl: productModel!
                                          .allProducts![index].productImageURL
                                          .toString(),
                                      productPrice: productModel!
                                          .allProducts![index].price
                                          .toString(),
                                      productRate: productModel!
                                          .allProducts![index].rate
                                          .toString(),
                                    ),
                                    productModel!
                                        .allProducts![index].productImageURL
                                        .toString(),
                                    productModel!
                                        .allProducts![index].productName
                                        .toString(),
                                    productModel!.allProducts![index].price
                                        .toString());
                              },
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen("hhhh"),
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
                              "Login",
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
                                builder: (context) => SignUpScreen("hhhhh"),
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
                              "Register",
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
                ],
              ),
            ),
    );
  }

  getAllStories() async {
    // await CacheHelper.init();
    // var access_token = CacheHelper.getData(key: 'access_token');
    // var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request(
        'GET', Uri.parse('https://oshops-app.herokuapp.com/getAllStores'));

    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      storiesModel = StoriesModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));
      setState(() {
        loading = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  getAllProducts() async {
    // await CacheHelper.init();
    // var access_token = CacheHelper.getData(key: 'access_token');
    // var headers = {'Authorization': 'Bearer $access_token'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://oshops-app.herokuapp.com/getAllProducts?page=1&size=4'));

    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(
          jsonDecode(await response.stream.bytesToString()));
      print(productModel!.allProducts!.length);
      setState(() {
        loadingProducts = false;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }
}
