import 'package:aj_chat_node/auth_service/auth_service.dart';
import 'package:aj_chat_node/main.dart';
import 'package:flutter/material.dart';

commonProfileNetworkImage(int userId) {
  return CircleAvatar(
    radius: 25,
    child: ClipOval(
      child: FutureBuilder<String?>(
        future: AuthService().getProfileImage(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Image.network(
              '$serverBaseUrl${snapshot.data!}',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return Image.asset(
                  'assets/images/pic.png',
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                );
              },
            );
          } else {
            return Image.asset(
              'assets/images/pic.png',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            );
          }
        },
      ),
    ),
  );
}
