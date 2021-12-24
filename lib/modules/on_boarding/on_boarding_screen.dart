// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, avoid_print, no_logic_in_create_state, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/bottom_navigator_bar.dart';
import 'package:shop_app/screens/fakeData/fakeHomePage.dart';

import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image1;
  final String image2;

  BoardingModel({
    required this.image1,
    required this.image2,
  });
}

class OnBoardingScreen extends StatefulWidget {
  final String? token;
  const OnBoardingScreen(this.token);
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState(token);
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final String? token;
  _OnBoardingScreenState(this.token);
  var boardingController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image1: 'assets/images/OShops.png',
      image2: 'assets/images/1.png',
    ),
    BoardingModel(
      image1: 'assets/images/OShops.png',
      image2: 'assets/images/2.png',
    ),
    BoardingModel(
      image1: 'assets/images/OShops.png',
      image2: 'assets/images/3.png',
    ),
  ];

  void submit() {
    CacheHelper.saveData(
      key: 'onBoarding',
      value: true,
    ).then((value) {
      if (value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                token == null ? FakeHomePage() : BottomNavigationScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text('skip',
                  style: TextStyle(fontSize: 25, fontFamily: 'SFProDisplay')),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardingController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    print('last');
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    print('not last');
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder: (context, item) =>
                    buildBoardingItem(boarding[item]),
                itemCount: boarding.length,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardingController,
                  effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 5,
                      expansionFactor: 4),
                  count: boarding.length,
                ),
                Spacer(),
                FlatButton(
                  onPressed: () {
                    isLast
                        ? Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FakeHomePage(),
                            ),
                            (route) => false,
                          )
                        : boardingController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                  },
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Column buildBoardingItem(BoardingModel model) {
    return Column(
      children: [
        Expanded(
          child: Image(
            image: AssetImage('${model.image1}'),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Expanded(
          child: Image(
            image: AssetImage('${model.image2}'),
          ),
        ),
      ],
    );
  }
}
