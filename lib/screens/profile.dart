// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, sized_box_for_whitespace, deprecated_member_use, non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables, prefer_if_null_operators

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/cubit/api_services/api_services_cubit.dart';
import 'package:shop_app/constants/toast_constant.dart';
import 'package:shop_app/models/constants.dart';
import 'package:shop_app/screens/edit_profile.dart';
import 'package:shop_app/screens/shopping_address.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/modules/login/log_in_form.dart';

import 'card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var titleTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );

  File? imageFile;

  void showCameraDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'please choose an option',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: pickImageWithCamera,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'camera',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        )
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: pickImageWithGallery,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'gallery',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        )
                      ]),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  void pickImageWithCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, maxWidth: 1080, maxHeight: 1080);

    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void pickImageWithGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1080, maxHeight: 1080);
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void cropImage(filePath) async {
    File? cropImage = await ImageCropper.cropImage(
        sourcePath: filePath, maxWidth: 1080, maxHeight: 1080);
    if (cropImage != null) {
      setState(() {
        filePath = cropImage;
      });
    }
  }

  String? token;
  getAccessToken() async {
    await CacheHelper.init();
    var access_token = CacheHelper.getData(key: 'access_token');
    print("the token is $access_token");
    await ApiServicesCubit.getInstance(context)
        .getCurrentUser(token: access_token);
    token = access_token;
  }

  @override
  void initState() {
    super.initState();
    getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                child: GestureDetector(
                  onTap: showCameraDialog,
                  child: Container(
                    width: size.width * 0.3,
                    height: size.width * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 9,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      shape: BoxShape.circle,
                    ),
                    child: imageFile == null
                        ? Image.network(
                            'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_boy_person_people_avatar_icon_159358.png',
                          )
                        : Image.file(
                            imageFile!,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              BlocBuilder<ApiServicesCubit, ApiServicesStates>(
                builder: (context, state) {
                  var firstName, lastName, email, address;
                  if (state is UserInfoLoadedState) {
                    firstName = state.data["userData"]["firstName"];
                    lastName = state.data["userData"]["lastName"];
                    email = state.data["userData"]["email"];
                    address = state.data["userData"]["address"];
                    print(email);
                  } else if (state is UserInfoUnLoadedState) {
                    ToastConstant.showToast(context, state.error);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 15,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              firstName == null
                                  ? "Name"
                                  : "$firstName $lastName",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 15,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              email == null ? "email" : email,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 15,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              address == null ? "address" : address,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          buildGestureDetector(Icons.edit, 'Edit Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(),
              ),
            );
          }),
          SizedBox(
            height: 20,
          ),
          buildGestureDetector(Icons.location_on_outlined, 'Address', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingAddress(),
              ),
            );
          }),
          SizedBox(
            height: 20,
          ),
          buildGestureDetector(Icons.shopping_cart, 'Card', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardScreen(),
              ),
            );
          }),
          SizedBox(
            height: 20,
          ),
          buildGestureDetector(Icons.logout, 'Log Out', () {
            final alert = AlertDialog(
              title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Are you sure to log out?',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
              content: Row(
                children: [
                  Container(
                    height: 40,
                    child: TextButton(
                        onPressed: () async {
                          await CacheHelper.init();
                          CacheHelper.deleteData(key: "access_token")
                              .then((value) {
                            if (value) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(" "),
                                ),
                              );
                            }
                          });
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        )),
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        )),
                  ),
                ],
              ),
            );
            showDialog(builder: (context) => alert, context: context);
          }),
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(icon, text, fun) {
    return GestureDetector(
      onTap: fun,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon),
              ),
              color: light,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
