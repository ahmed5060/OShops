import 'package:shop_app/models/login_model.dart';

abstract class ShopSignUpStates{}

class ShopSignUpInitialState extends ShopSignUpStates{}

class ShopSignUpLoadingState extends ShopSignUpStates{}

class ShopSignUpSuccessState extends ShopSignUpStates{

  final ShopLoginModel loginModel;

  ShopSignUpSuccessState(this.loginModel);

}

class ShopSignUpErrorState extends ShopSignUpStates{
  final String error;

  ShopSignUpErrorState(this.error);
}

class ShopSignUpChangPasswordVisibilityState extends ShopSignUpStates{}
