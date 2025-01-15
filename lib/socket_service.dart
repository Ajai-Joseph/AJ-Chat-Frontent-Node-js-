import 'dart:developer';

import 'package:aj_chat_node/main.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket? socket;

void initializeSocket(int currentUserId) {
  log('socket reg: $currentUserId');
  socket = io(serverBaseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  socket!.connect();
  socket!.onConnect((_) {
    log('Connected to Socket.IO server');
    socket!.emit('register', currentUserId);
  });
}
