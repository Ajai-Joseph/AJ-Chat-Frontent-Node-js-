import 'dart:developer';

import 'package:aj_chat_node/main.dart';
import 'package:dio/dio.dart';

class MessageService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '$serverBaseUrl/api/messages',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  Future<List<Map<String, dynamic>>> fetchRecentChats() async {
    try {
      final response = await _dio.get('/recentChats',
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
      print('Error fetching recent chats: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchChatHistory(
      int senderId, int receiverId) async {
    try {
      final response = await _dio.get('/getChatHistory',
          data: {
            'senderId': senderId,
            'receiverId': receiverId,
          },
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
      print('Error fetching chat history: $e');
      return [];
    }
  }

  // Send a message using the Node.js API
  Future<bool> sendMessage(
      int senderId, int receiverId, String senderName, String content) async {
    try {
      final response = await _dio.post('/sendMessage',
          data: {
            'content': content,
            'senderId': senderId,
            'receiverId': receiverId,
            "senderName": senderName
          },
          options: Options(headers: {
            "Authorization":
                "Bearer ${currentlyLoggedInUserDetailsMap!["token"]}"
          }));

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }
}
