import 'dart:developer';
import 'dart:io';

import 'package:aj_chat_node/main.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$serverBaseUrl/api/auth',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name,
        'email': email,
        'password': password,
        'profileImage': await MultipartFile.fromFile(profileImage.path),
      });

      Response response = await _dio.post('/register', data: formData);

      if (response.statusCode == 200) {
        log(response.data.toString());
        return true;
      } else {
        throw Exception('Failed to register user');
      }
    } on DioError catch (e) {
      log(e.toString());
      return false;
      // if (e.response != null) {
      //   return {
      //     'error': true,
      //     'message': e.response?.data['message'] ?? 'Unknown error occurred',
      //   };
      // } else {
      //   return {'error': true, 'message': e.message};
      // }
    }
  }

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> data = {
        'email': email,
        'password': password,
      };

      Response response = await _dio.post('/login', data: data);

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioError catch (e) {
      // if (e.response != null) {
      //   return {
      //     'error': true,
      //     'message': e.response?.data['message'] ?? 'Unknown error occurred',
      //   };
      // } else {
      //   // Error on request sending side (e.g., no internet connection)
      //   return {'error': true, 'message': e.message};
      // }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await _dio.get('/getAllUsers',
          options: Options(headers: {
            "Authorization":
                "Bearer ${currentlyLoggedInUserDetailsMap!["token"]}"
          }));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String?> getProfileImage(int userId) async {
    try {
      final response = await _dio.get('/getProfileImage',
          options: Options(headers: {
            "Authorization":
                "Bearer ${currentlyLoggedInUserDetailsMap!["token"]}"
          }));

      if (response.statusCode == 200) {
        return response.data["profileImageUrl"];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> logoutUser() async {
    try {
      Response response = await _dio.post('/logout',
          options: Options(headers: {
            "Authorization":
                "Bearer ${currentlyLoggedInUserDetailsMap!["token"]}"
          }));

      if (response.statusCode == 200) {
        log(response.data.toString());
        return true;
      }
      return false;
    } on DioError catch (e) {
      log(e.toString());
      return false;
    }
  }
}
