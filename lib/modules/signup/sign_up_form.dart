// ignore_for_file: prefer_const_constructors, avoid_print, must_be_immutable, prefer_const_literals_to_create_immutables, deprecated_member_use
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/models/constants.dart';

import 'package:shop_app/modules/login/log_in_form.dart';
import 'package:shop_app/modules/signup/cubit/cubit.dart';

import 'cubit/states.dart';

class SignUpScreen extends StatelessWidget {
  final String? token;

  SignUpScreen(this.token, {Key? key}) : super(key: key);

  var formSignupKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _firstNameController = TextEditingController();
    var _lastNameController = TextEditingController();
    var _emailController = TextEditingController();
    var _passwordController = TextEditingController();
    print("my token $token");
    //Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ShopSignUpCubit(),
      child: BlocConsumer<ShopSignUpCubit, ShopSignUpStates>(
        listener: (context, state) {
          if (state is ShopSignUpSuccessState) {
            if (state.loginModel.message == "Success") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(token),
                ),
              );
              // CacheHelper.saveData(
              //   key: 'access_token',
              //   value: state.loginModel.token,
              // ).then((value) {
              //   print("***************");
              //   print(value.toString());
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => BottomNav(token),
              //     ),
              //   );
              // });
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
                          style: TextStyle(fontSize: 15, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
          if (state is ShopSignUpErrorState) {
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                  key: formSignupKey,
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
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(token),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'enter your first name',
                                    labelText: 'First Name',
                                    // style: TextStyle(color: signup_bg),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _lastNameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your last name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'enter your last name',
                                    labelText: 'Last Name',
                                    // style: TextStyle(color: signup_bg),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _emailController,
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
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password is too short';
                                      } else {
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText:
                                        ShopSignUpCubit.get(context).isPassword,
                                    onFieldSubmitted: (value) {
                                      if (formSignupKey.currentState!
                                          .validate()) {
                                        FocusScope.of(context).unfocus();
                                        ShopSignUpCubit.get(context).userSignUp(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                      }
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            ShopSignUpCubit.get(context)
                                                .changePasswordVisibility();
                                          },
                                          child: Icon(
                                              ShopSignUpCubit.get(context)
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
                                SizedBox(
                                  height: 30,
                                ),
                                BuildCondition(
                                  condition: state is! ShopSignUpLoadingState,
                                  builder: (context) => FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    minWidth: 500,
                                    color: signup_bg,
                                    onPressed: () {
                                      if (formSignupKey.currentState!
                                          .validate()) {
                                        FocusScope.of(context).unfocus();
                                        ShopSignUpCubit.get(context).userSignUp(
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      'register'.toUpperCase(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  fallback: (context) => Center(
                                    child: CircularProgressIndicator(
                                      color: signup_bg,
                                    ),
                                  ),
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
