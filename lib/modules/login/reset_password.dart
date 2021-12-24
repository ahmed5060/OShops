// ignore_for_file: avoid_returning_null_for_void, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, no_logic_in_create_state, prefer_final_fields, prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/cubit/api_services/api_services_cubit.dart';
import 'package:shop_app/constants/toast_constant.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/modules/login/log_in_form.dart';
import 'package:shop_app/screens/bottom_navigator_bar.dart';

class ResetPassword extends StatefulWidget {
  final String? token;

  ResetPassword(this.token);
  @override
  State<ResetPassword> createState() => _ResetPasswordState(token!);
}

class _ResetPasswordState extends State<ResetPassword> {
  final String token;
  _ResetPasswordState(this.token);
  var _passwordControllerOld = TextEditingController();

  var _passwordControllerNew = TextEditingController();

  var resetKey = GlobalKey<FormState>();

  bool isPassword = true;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          onPressed: () {
            //Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(token),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Image.asset(
              'assets/images/OShops.png',
              height: 150,
              width: 150,
            ),
            Form(
              key: resetKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Reset Your Password',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defpaultPadding),
                    child: TextFormField(
                      controller: _passwordControllerOld,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password Password is empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'enter your old password',
                        labelText: 'Old Password',
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defpaultPadding),
                    child: TextFormField(
                      controller: _passwordControllerNew,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'enter your new password',
                        labelText: 'New Password',
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocListener<ApiServicesCubit, ApiServicesStates>(
                      listener: (context, state) {
                        if (state is SuccessResetPasswordState) {
                          ToastConstant.showToast(context, state.message);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigationScreen(),
                            ),
                          );
                        } else if (state is FailedRestPasswordState) {
                          setState(() {
                            isChecked = false;
                          });
                          ToastConstant.showToast(context, state.error);
                        }
                      },
                      child: BlocBuilder<ApiServicesCubit, ApiServicesStates>(
                        builder: (context, state) {
                          return FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minWidth: 500,
                            color: signup_bg,
                            onPressed: () async {
                              print(
                                "${_passwordControllerOld.text} + ${_passwordControllerNew.text}+$token",
                              );
                              setState(() {
                                isChecked = true;
                              });
                              if (resetKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                print("object");
                                await ApiServicesCubit.getInstance(context)
                                    .changePassword(
                                  oldPassword:
                                      _passwordControllerOld.text.toString(),
                                  newPassword:
                                      _passwordControllerNew.text.toString(),
                                  token: token,
                                );
                              } else {
                                setState(() {
                                  isChecked = false;
                                });
                              }
                            },
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isChecked,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
