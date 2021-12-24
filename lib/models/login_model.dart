
class ShopLoginModel{
  int? status;
  String? message;
  String? token;
  UserData? data;

  ShopLoginModel.fromJson(Map<String, dynamic> josn){
  status = josn['status'];
  message = josn['message'];
  token = josn['token'];
  // data = josn['data'] != null ? UserData.fromJson(josn['data']) : null;
  }

}
//
class UserData{
  late String token;


  UserData.fromJson(Map<String, dynamic> josn){
    token = josn['token'];
  }

}