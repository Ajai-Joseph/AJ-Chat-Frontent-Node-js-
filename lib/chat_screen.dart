import 'dart:developer';

import 'package:aj_chat_node/common_network_image.dart';
import 'package:aj_chat_node/home_screen.dart';
import 'package:aj_chat_node/main.dart';
import 'package:aj_chat_node/message_service/message_service.dart';
import 'package:aj_chat_node/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  final int receiverId;
  final String receiverName;

  ChatScreen({
    required this.receiverId,
    required this.receiverName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int currentUserId = currentlyLoggedInUserDetailsMap!['user']['id'];
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialMessages();
    socket!.on('receive_message', (data) {
      log('receive_message: $data');
      if (mounted) {
        setState(() {
          messages.insert(0, data);
        });
      }
    });
  }

  // Fetch initial chat history
  Future<void> _fetchInitialMessages() async {
    try {
      var fetchedMessages = await MessageService().fetchChatHistory(
        currentUserId,
        widget.receiverId,
      );
      setState(() {
        messages = fetchedMessages;
      });
    } catch (error) {
      print('Error fetching initial messages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Header section with receiver details
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              color: Colors.purple.shade900,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      commonProfileNetworkImage(widget.receiverId),
                      SizedBox(width: 10),
                      Text(
                        widget.receiverName,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.call, color: Colors.purple.shade900),
                        ),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.video_call,
                            color: Colors.purple.shade900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Messages list and input field
            Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              margin: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.all(5),
                      itemBuilder: (context, index) {
                        var messageData = messages[index];
                        DateTime dateTime =
                            DateTime.parse(messageData['createdAt']);

                        return Row(
                          mainAxisAlignment:
                              messageData['senderId'] == currentUserId
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  messageData['senderId'] == currentUserId
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        messageData['senderId'] == currentUserId
                                            ? Colors.purple.shade900
                                            : Colors.grey.shade300,
                                  ),
                                  child: Text(
                                    messageData['content'],
                                    style: TextStyle(
                                      color: messageData['senderId'] ==
                                              currentUserId
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  " ${DateFormat.jm().format(dateTime.toLocal())} ",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemCount: messages.length,
                    ),
                  ),
                  // Message input field
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Type your message",
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 10, 10, 10),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        CircleAvatar(
                          backgroundColor: Colors.purple.shade900,
                          radius: 21,
                          child: IconButton(
                            onPressed: () async {
                              if (messageController.text.isEmpty) return;

                              String message = messageController.text;
                              messageController.clear();
                              await MessageService().sendMessage(
                                  currentUserId,
                                  widget.receiverId,
                                  currentlyLoggedInUserDetailsMap!['user']
                                      ['name'],
                                  message);
                              // Sending the message via Socket.IO
                              // socket!.emit('send_message', {
                              //   'senderId': currentUserId,
                              //   'receiverId': widget.receiverId,
                              //   'senderName':
                              //       currentlyLoggedInUserDetailsMap!['user']
                              //           ['name'],
                              //   'content': message,
                              // });

                              // Locally adding the message to the list for immediate UI update
                              setState(() {
                                messages.insert(0, {
                                  'senderId': currentUserId,
                                  'receiverId': widget.receiverId,
                                  'content': message,
                                  'createdAt': DateTime.now().toIso8601String(),
                                });
                              });
                            },
                            icon: Icon(Icons.send),
                            color: Colors.white,
                          ),
                        ),
                      ],
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
