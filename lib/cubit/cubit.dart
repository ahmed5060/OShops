// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/models/stores_model.dart';
import 'package:shop_app/models/user_model.dart';
import 'package:shop_app/screens/card.dart';
import 'package:shop_app/screens/profile.dart';
import 'package:shop_app/screens/shopping.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomsScreens = [
    ShoppingScreen(),
    ProfileScreen(),
    CardScreen()
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  //String? orderId = 'FY0NY8piDFMtDGZH_SoQn';

  StoriesModel? storesModel;
  List<dynamic> allStores = [];
  void getStores({required String token}) {
    emit(ShopLoadingStoresDataState());

    DioHelper.getData(
      url: '/getAllStores',
      token: token,
    ).then((value) {
      //print(value.data['allStores'][0]['storeName']);
      allStores = value.data['allStores'];
      print(allStores[0]['storeName']);
      storesModel = StoriesModel.fromJson(value.data);
      emit(StoreSuccessState(storesModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorState(error.toString()));
    });
  }

  UserModel? userModel;
  List<dynamic> userData = [];
  void getUser({required String token}) {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: '/getCurrentUser',
      token:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MThkOWYyNzM0OWFhYTliYTExYjU4NjMiLCJyb2xlIjoidXNlciIsImlhdCI6MTYzNzcxODAwN30.d1ZPI_TQu2kn2d8vLlJ7u_rDhwm3wayA58oYmG5u4zo',
    ).then((value) {
      //print(value.data['userData'][0]['storeName']);
      userData = value.data['userData'];
      print('333333333333333333333333333333333333333333333333333333');
      userModel = UserModel.fromJson(value.data);
      emit(UserSuccessState(userModel!));
    }).catchError((error) {
      print(error.toString());
      print('090909090909090900000909090009090900900090009090900909');
      emit(UserErrorState(error.toString()));
    });
  }

  ProductModel? productModel;
  List<dynamic> allProducts = [];
  void getProducts({required String token}) {
    emit(ShopLoadingProductsDataState());

    DioHelper.getData(
      url: '/getAllProducts',
      query: {'page': '1', 'size': '4'},
      token: token,
    ).then((value) {
      //print(value.data['allProducts'][0]['productName']);
      allProducts = value.data['allProducts'];
      print(allProducts[0]['productName']);
      storesModel = StoriesModel.fromJson(value.data);
      emit(StoreSuccessState(storesModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorState(error.toString()));
    });
  }

  CategoriesModel? categoriesModel;
  List<dynamic> storeCategories = [];
  void getCategories({required String token}) {
    emit(ShopLoadingCategoriesDataState());

    DioHelper.getData(
      url: '/getStoreCategories',
      //id: id,
      query: {'page': '1', 'size': '1'},
      token: token,
    ).then((value) {
      //print(value.data['storeCategories'][0]['productName']);
      storeCategories = value.data['storeCategories'];
      print(storeCategories[0]['categoryName']);
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(CategoriesSuccessState(categoriesModel!));
    }).catchError((error) {
      print(error.toString());
      emit(CategoriesErrorState(error.toString()));
    });
  }
}
