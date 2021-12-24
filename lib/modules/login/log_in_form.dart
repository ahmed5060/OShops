// ignore_for_file: prefer_const_constructors, avoid_print, must_be_immutable, deprecated_member_use
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/login/reset_password.dart';
import 'package:shop_app/modules/signup/sign_up_form.dart';
import 'package:shop_app/screens/bottom_navigator_bar.dart';

import 'package:shop_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  final String? token;

  LoginScreen(this.token, {Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _emailControllerLog = TextEditingController();
    var _passwordControllerLog = TextEditingController();

    //Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.message == "Success") {
              CacheHelper.saveData(
                key: 'access_token',
                value: state.loginModel.token,
              ).then((value) {
                print("***************");
                print(value.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(),
                  ),
                );
              });
              String? m = state.loginModel.message;
              var fToast = FToast();
              fToast.init(context);
              fToast.showToast(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                          m!,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              print(state.loginModel.message);
            } else {
              String? m = state.loginModel.message;
              var fToast = FToast();
              fToast.init(context);
              fToast.showToast(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                          m!,
                          style: TextStyle(fontSize: 5, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              print(state.loginModel.message);
              print(state.loginModel.status);
              print(state.loginModel.data);
            }
          }
          if (state is ShopLoginErrorState) {
            print(state.error.toString());
            var fToast = FToast();
            fToast.init(context);
            fToast.showToast(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        state.error.toString(),
                        style: TextStyle(
                            fontSize: 5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
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
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text('Login to continue',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ))),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _emailControllerLog,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'enter your email',
                                    labelText: 'Email',
                                    // style: TextStyle(color: signup_bg),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defpaultPadding),
                                  child: TextFormField(
                                    controller: _passwordControllerLog,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password is too short';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onFieldSubmitted: (value) {
                                      if (formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        ShopLoginCubit.get(context).userLogin(
                                          email: _emailControllerLog.text,
                                          password: _passwordControllerLog.text,
                                        );
                                      }
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText:
                                        ShopLoginCubit.get(context).isPassword,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            ShopLoginCubit.get(context)
                                                .changePasswordVisibility();
                                          },
                                          child: Icon(
                                              ShopLoginCubit.get(context)
                                                  .suffix)),
                                      hintText: 'enter your password',
                                      labelText: 'Password',
                                      //style: TextStyle(color: signup_bg),

                                      errorBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ResetPassword(token),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Reset Password?",
                                      style:
                                          TextStyle(color: Color(0xFF3F6B93)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                BuildCondition(
                                  condition: state is! ShopLoginLoadingState,
                                  builder: (context) => FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minWidth: 500,
                                    color: signup_bg,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        ShopLoginCubit.get(context).userLogin(
                                          email: _emailControllerLog.text,
                                          password: _passwordControllerLog.text,
                                        );
                                      }
                                    },
                                    child: Text('sign in'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ),
                                  fallback: (context) => Center(
                                      child: CircularProgressIndicator(
                                    color: signup_bg,
                                  )),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't Have An Account ?"),
                                    TextButton(
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 17),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen(token),
                                          ),
                                        );
                                      },
                                    )
                                  ],
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
        },
      ),
    );
  }
}
