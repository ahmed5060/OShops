
// ignore_for_file: file_names, prefer_typing_uninitialized_variables

class UserModel{
  String? message;
  var userData;


  UserModel.fromJson( Map<String,dynamic> json){
    message = json['message'];
    userData = json['userData'];
  }
}