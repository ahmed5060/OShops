// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/signup/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopSignUpCubit extends Cubit<ShopSignUpStates> {
  ShopSignUpCubit() : super(ShopSignUpInitialState());

  static ShopSignUpCubit get(context) => BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userSignUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) {

    emit(ShopSignUpLoadingState());


    DioHelper.postData(
      url: "/signUp",
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    ).then((value) {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSignUpSuccessState(loginModel!));
    }).catchError((error){
      print(error.response.data.toString());
      emit(ShopSignUpErrorState(error.response.data['message'].toString()));
    });
  }

  void postOrder(){
    emit(ShopSignUpLoadingState());

    DioHelper.postData(
      url: '/signUp',
      data: {
      "email": "mohamed.ragab@gmail.com",
      "password": "Mohamed1!"
    },
    ).then((value){
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopSignUpSuccessState(loginModel!));
    }).catchError((error){
      print("------------------------------");
      print(error.response.data);
      print(error.response.headers);
      print(error.message);
      emit(ShopSignUpErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;

  bool isPassword = true;

  void changePasswordVisibility(){

    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopSignUpChangPasswordVisibilityState());
  }

}
