// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/constants/strings.dart';
import 'package:http/http.dart' as http;

part 'api_Services_states.dart';

class ApiServicesCubit extends Cubit<ApiServicesStates> {
  ApiServicesCubit() : super(ApiServicesInitialState());

  static ApiServicesCubit getInstance(BuildContext context) {
    return BlocProvider.of<ApiServicesCubit>(context);
  }

  changePassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT',
        Uri.parse('https://oshops-app.herokuapp.com/$resetPasswordEndPoint'));
    request.body = json.encode({
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      emit(SuccessResetPasswordState(message: "Success"));
      print(await response.stream.bytesToString());
    } else {
      emit(FailedRestPasswordState(error: "UnSuccess"));
      print(response.reasonPhrase);
    }
  }

  editProfile(
      {required String firstName,
      required String lastName,
      required String email,
      required String token}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT',
        Uri.parse('https://oshops-app.herokuapp.com/$editUserProfileEndPoint'));
    request.body = json.encode(
      {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      },
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      emit(EditProfileSuccessState(message: "Success"));
      print(await response.stream.bytesToString());
    } else {
      emit(EditProfileUnSuccessState(error: "UnSuccess"));

      print(response.reasonPhrase);
    }
  }

  AddShoppingAddress({required String address, required String token}) async {
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('PUT',
        Uri.parse('https://oshops-app.herokuapp.com/$addAddressEndPoint'));
    request.body = json.encode(
      {
        "address": address,
      },
    );
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      emit(SuccessAddAdressState(message: "Success"));
      print(await response.stream.bytesToString());
    } else {
      emit(UnSucessAddedAdderessState(error: "UnSuccess"));
      print(response.reasonPhrase);
    }
  }

  getCurrentUser({required String token}) async {
    emit(UserInfoLoadingSate());
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET',
        Uri.parse('https://oshops-app.herokuapp.com/$getCurrentUserEndPoint'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var model = json.decode(await response.stream.bytesToString());
      print(model["message"]);
      print(model["userData"]["firstName"]);
      //print(await response.stream.bytesToString());
      emit(UserInfoLoadedState(data: model));
    } else {
      emit(UserInfoUnLoadedState(error: "No data at this time"));
      print(response.reasonPhrase);
    }
  }

  searchItem({required String token, required String param}) async {
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request(
      'GET',
      Uri.parse('https://oshops-app.herokuapp.com/productSearch?search=$param'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> products = [];
      var items = json
          .decode(await response.stream.bytesToString())
          .cast<String, dynamic>();
      //print(items);
      //ItemsModel model = ItemsModel.fromJson(items);
      print(items["data"]);
      items["data"].forEach((element) {
        products.add(element);
      });
      print(products.length);
      emit(SearchItemFoundState(items: products));
    } else {
      emit(SearchItemNotFoundState(error: "Not found at this time"));
      print(response.reasonPhrase);
    }
  }
}
