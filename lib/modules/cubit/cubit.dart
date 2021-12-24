import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/cubit/states.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());


  static ShopCubit get(context) => BlocProvider.of(context);
  int counter = 1;

}