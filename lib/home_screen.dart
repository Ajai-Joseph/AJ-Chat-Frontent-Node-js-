import 'package:aj_chat_node/auth_service/auth_service.dart';
import 'package:aj_chat_node/chat_screen.dart';
import 'package:aj_chat_node/common_loading.dart';
import 'package:aj_chat_node/common_network_image.dart';
import 'package:aj_chat_node/login.dart';
import 'package:aj_chat_node/main.dart';
import 'package:aj_chat_node/message_service/message_service.dart';
import 'package:aj_chat_node/socket_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentUserId = currentlyLoggedInUserDetailsMap!['user']['id'];
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Dio dio = Dio();
  bool search = false;
  TextEditingController searchController = TextEditingController();
  String? searchKey;
  int? searchKeyLength;

  List<Map<String, dynamic>> recentChatsList = [];
  List<Map<String, dynamic>> usersList = []; // Store users here

  @override
  void initState() {
    super.initState();
    initializeSocket(currentUserId);
    fetchRecentChats();
    fetchUsers(); // Fetch users on init

    socket!.on('receive_message', (data) {
      setState(() {
        int index = recentChatsList
            .indexWhere((msg) => msg["receiverId"] == data["senderId"]);

        if (index != -1) {
          recentChatsList[index] = {
            "receiverId": data["senderId"],
            "receiverName": data["senderName"],
            "lastMessage": data["content"],
            "createdAt": DateTime.now().toIso8601String()
          };
        } else {
          recentChatsList.add({
            "receiverId": data["senderId"],
            "receiverName": data["senderName"],
            "lastMessage": data["content"],
            "createdAt": DateTime.now().toIso8601String()
          });
        }
      });
    });

    // Listen for new users added via socket
    socket!.on('new_user_added', (userData) {
      setState(() {
        usersList.add(userData);
      });
    });
  }

  Future<void> fetchRecentChats() async {
    try {
      List<Map<String, dynamic>> recentChats =
          await MessageService().fetchRecentChats();
      setState(() {
        recentChatsList = recentChats;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching chats: $e');
    }
  }

  Future<void> fetchUsers() async {
    try {
      List<Map<String, dynamic>> users = await AuthService().fetchUsers();
      setState(() {
        usersList = users; // Store fetched users in the list
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching users: $e');
    }
  }

  Future<void> logout() async {
    commonLoading(context);
    bool success = await AuthService().logoutUser();
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      currentlyLoggedInUserDetailsMap = null;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Logout failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: globalKey,
        drawer: drawer(context),
        body: Stack(
          children: [
            // Top Section with Users
            Container(
              padding: EdgeInsets.only(left: 10),
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.purple.shade900,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            globalKey.currentState!.openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        IconButton(
                          onPressed: logout,
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Displaying users from usersList
                  Container(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> user = usersList[index];
                        if (user['id'] != currentUserId) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiverId: user['id'],
                                    receiverName: user['name'],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                commonProfileNetworkImage(
                                    user['id']),
                                Text(
                                  user['name'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox();
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 5),
                      itemCount: usersList.length,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Section for Recent Chats and Search
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(top: 120),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        suffixIcon: search
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    search = false;
                                  });
                                },
                                icon: Icon(Icons.clear),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchKey = value;
                          searchKeyLength = searchKey!.length;
                          search = true;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: search == false
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                var chat = recentChatsList[index];
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          receiverId: chat['receiverId'],
                                          receiverName: chat['receiverName'],
                                        ),
                                      ),
                                    );
                                  },
                                  horizontalTitleGap: 10,
                                  leading: commonProfileNetworkImage(
                                      chat['receiverId']),
                                  title: Text(chat['receiverName']),
                                  subtitle: Text(chat['lastMessage']),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10),
                              itemCount: recentChatsList.length,
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) {
                                var user = usersList[index];
                                if (user['id'] != currentUserId &&
                                    searchKeyLength! <= user['name'].length &&
                                    user['name']
                                            .toString()
                                            .substring(0, searchKeyLength!)
                                            .toLowerCase() ==
                                        searchKey!.toLowerCase()) {
                                  return ListTile(
                                    onTap: () {
                                      searchController.clear();
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            receiverId: user['id'],
                                            receiverName: user['name'],
                                          ),
                                        ),
                                      );
                                      setState(() {
                                        search = false;
                                      });
                                    },
                                    horizontalTitleGap: 10,
                                    leading: commonProfileNetworkImage(
                                        user['id']),
                                    title: Text(user['name']),
                                  );
                                }
                                return SizedBox();
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 5),
                              itemCount: usersList.length,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget drawer(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.6,
    child: Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: 120,
            color: Colors.purple.shade900,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Chat App',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            onTap: () {},
            title: Text('Item 1'),
          ),
          ListTile(
            onTap: () {},
            title: Text('Item 2'),
          ),
        ],
      ),
    ),
  );
}
