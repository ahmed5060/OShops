// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://oshops-app.herokuapp.com',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    String? token,
    Map<String, dynamic>? query,
    String? id,
  }) async {
    dio.options.headers["Authorization"] = "Bearer ${token}";
    return await dio.get(url);
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(
      url,
      data: data,
    );
  }
}

// import 'package:dio/dio.dart';
//
// class DioHelper{
//   static late Dio dio;
//
//   static void init(){
//     dio = Dio(
//         BaseOptions(
//             baseUrl: "https://oshops-app.herokuapp.com",
//             receiveDataWhenStatusError: true,
//             headers: {
//               "Content-Type" :"application/json",
//               "lang" : "ar"
//             }
//         )
//     );
//   }
//
//   static Future<Response> getData(
//       {
//         required String url,
//       }
//       )async{
//     //dio.options.headers["Authorization"] = "Bearer 9941df1208c615c231c21671041566390be6a911743b7a9b7fd461d6a3546a0a";
//     return await dio.get(url);
//   }
//
//
//   static Future<Response> postData({
//     required String url,
//     required Map<String,dynamic> data,
//   }) async
//   {
//     //dio.options.headers["authorization"] = "token ${token}";
//     //dio.options.headers["Authorization"] = "Bearer 9941df1208c615c231c21671041566390be6a911743b7a9b7fd461d6a3546a0a";
//     return dio.post(
//         url,
//         data:data
//     );
//   }
//
//   static Future<Response> putData({
//     required String url,
//     required Map<String,dynamic> data,
//   }) async
//   {
//     //dio.options.headers["Authorization"] = "Bearer 9941df1208c615c231c21671041566390be6a911743b7a9b7fd461d6a3546a0a";
//     return dio.patch(
//         url,
//         data:data
//     );
//   }
//
//   static Future<Response> deleteData({
//     required String url,
//   }) async
//   {
//     //dio.options.headers["Authorization"] = "Bearer 9941df1208c615c231c21671041566390be6a911743b7a9b7fd461d6a3546a0a";
//     return dio.delete(
//       url,
//     );
//   }
//
//
// }
