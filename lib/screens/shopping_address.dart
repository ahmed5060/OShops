// ignore_for_file: avoid_returning_null_for_void, prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, deprecated_member_use, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/cubit/api_services/api_services_cubit.dart';
import 'package:shop_app/constants/toast_constant.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/screens/bottom_navigator_bar.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShoppingAddress extends StatefulWidget {
  @override
  State<ShoppingAddress> createState() => _ShoppingAddressState();
}

class _ShoppingAddressState extends State<ShoppingAddress> {
  var _addressController = TextEditingController();
  var formSignupKey = GlobalKey<FormState>();

  var resetKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: formSignupKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/OShops.png',
                    height: 150,
                    width: 150,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add your shopping address',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _addressController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your shopping address';
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'enter your shopping address',
                              labelText: 'Shopping Address',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BlocListener<ApiServicesCubit, ApiServicesStates>(
                            listener: (context, state) {
                              if (state is SuccessAddAdressState) {
                                ToastConstant.showToast(context, state.message);
                                setState(() {
                                  isChecked = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BottomNavigationScreen(),
                                  ),
                                );
                              } else if (state is UnSucessAddedAdderessState) {
                                setState(() {
                                  isChecked = false;
                                });
                                ToastConstant.showToast(context, state.error);
                              }
                            },
                            child: BlocBuilder<ApiServicesCubit,
                                ApiServicesStates>(
                              builder: (context, state) {
                                return FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minWidth: 500,
                                  color: signup_bg,
                                  onPressed: () async {
                                    setState(() {
                                      isChecked = true;
                                    });
                                    if (formSignupKey.currentState!
                                        .validate()) {
                                      FocusScope.of(context).unfocus();
                                      await CacheHelper.init();
                                      var access_token = CacheHelper.getData(
                                          key: 'access_token');
                                      print("the token is $access_token");
                                      await ApiServicesCubit.getInstance(
                                              context)
                                          .AddShoppingAddress(
                                        address: _addressController.text,
                                        token: access_token,
                                      );
                                    } else {
                                      setState(() {
                                        isChecked = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Submit'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: isChecked,
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
