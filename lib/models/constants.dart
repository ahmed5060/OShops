// ignore_for_file: constant_identifier_names, avoid_print

import 'package:flutter/material.dart';

const Color login_bg = Color(0xFFFAFAFA);
const Color signup_bg = Color(0xFF0F68B3);
const Color darkBlue = Color(0xFF00325A);
const Color light = Color(0xFF9BD3FF);
const Color g = Color(0xFFE3E3E3);

const double defpaultPadding = 16.0;
const Duration defaultDuration = Duration(milliseconds: 300);


// base url : 'https://newsapi.org/'
// method url : v2/top-headlines?

//https://oshops-app.herokuapp.com/getStoreCategories/:id?page=1&size=1

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
