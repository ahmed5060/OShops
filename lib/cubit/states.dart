import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/stores_model.dart';
import 'package:shop_app/models/user_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingStoresDataState extends ShopStates {}

class StoreSuccessState extends ShopStates {
  final StoriesModel storesModel;
  StoreSuccessState(this.storesModel);
}

class ErrorState extends ShopStates {
  final String error;
  ErrorState(this.error);
}

class ShopLoadingProductsDataState extends ShopStates {}

class ProductsSuccessState extends ShopStates {}

class ProductsErrorState extends ShopStates {
  final String error;
  ProductsErrorState(this.error);
}

class ShopLoadingCategoriesDataState extends ShopStates {}

class CategoriesSuccessState extends ShopStates {
  final CategoriesModel categoriesModel;
  CategoriesSuccessState(this.categoriesModel);
}

class CategoriesErrorState extends ShopStates {
  final String error;
  CategoriesErrorState(this.error);
}

class ShopLoadingUserDataState extends ShopStates {}

class UserSuccessState extends ShopStates {
  final UserModel userModel;
  UserSuccessState(this.userModel);
}

class UserErrorState extends ShopStates {
  final String error;
  UserErrorState(this.error);
}
