// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shop_app/business_logic/cubit/api_services/api_services_cubit.dart';
import 'package:shop_app/modules/cubit/cubit.dart';
import 'package:shop_app/modules/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'modules/on_boarding/on_boarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  DioHelper.init();
  await CacheHelper.init();
  var access_token = CacheHelper.getData(key: 'access_token');
  print("the token is $access_token");
  runApp(MyApp(access_token));
}

class MyApp extends StatelessWidget {
  final String? token;
  MyApp(this.token);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // registeration cubit
        BlocProvider<ApiServicesCubit>(
          create: (context) {
            return ApiServicesCubit();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OnBoardingScreen(token),

        //home: CardScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: Center(),
          );
        },
      ),
    );
  }
}
