// import 'package:aj_chat/chat.dart';
// import 'package:aj_chat/login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   int? searchKeyLength;
//   TextEditingController searchController = TextEditingController();
//   late bool search;
//   String? searchKey;
//   late String userId;
//   @override
//   void initState() {
//     search = false;
//     userId = auth.currentUser!.uid;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         key: globalKey,
//         drawer: drawer(context),
//         body: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.only(
//                 left: 10,
//               ),
//               height: MediaQuery.of(context).size.height / 2,
//               color: Colors.purple.shade900,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 35,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             globalKey.currentState!.openDrawer();
//                           },
//                           icon: Icon(
//                             Icons.menu,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () async {
//                             try {
//                               final sharedPreference =
//                                   await SharedPreferences.getInstance();
//                               await sharedPreference.clear();
//                               auth.signOut().then((value) => {
//                                     Navigator.pushAndRemoveUntil(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 LoginScreen()),
//                                         (route) => false)
//                                   });
//                             } catch (e) {
//                               Fluttertoast.showToast(msg: "Failed to logout");
//                             }
//                           },
//                           icon: Icon(
//                             Icons.logout,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     height: 70,
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance
//                           .collection("Users")
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemBuilder: (context, index) {
//                               QueryDocumentSnapshot x =
//                                   snapshot.data!.docs[index];
//                               if (snapshot.hasData && x['Id'] != userId) {
//                                 return Column(
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () => {
//                                         FocusScope.of(context).unfocus(),
//                                         Navigator.of(context).push(
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ChatScreen(receiverId: x['Id']),
//                                           ),
//                                         ),
//                                       },
//                                       child: CircleAvatar(
//                                         backgroundImage:
//                                             NetworkImage(x['Image']),
//                                       ),
//                                     ),
//                                     Text(
//                                       x['Name'],
//                                       style: TextStyle(
//                                           // fontSize: 15,
//                                           color: Colors.white),
//                                     ),
//                                   ],
//                                 );
//                               } else {
//                                 return SizedBox();
//                               }
//                             },
//                             separatorBuilder: (context, index) {
//                               return SizedBox(
//                                 width: 5,
//                               );
//                             },
//                             itemCount: snapshot.data!.docs.length,
//                           );
//                         } else {
//                           return CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 FocusScope.of(context).unfocus();
//               },
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40)),
//                   color: Colors.white,
//                 ),
//                 margin: EdgeInsets.only(
//                   top: 110,
//                   // left: 10,
//                   // right: 10,
//                 ),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: searchController,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         isDense: true,
//                         contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                         suffixIcon: search == false
//                             ? IconButton(
//                                 onPressed: () {},
//                                 icon: Icon(
//                                   Icons.search,
//                                 ),
//                               )
//                             : IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     searchController.clear();
//                                     search = false;
//                                   });
//                                 },
//                                 icon: Icon(
//                                   Icons.clear,
//                                 ),
//                               ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(40),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         if (value.isEmpty) {
//                           setState(() {
//                             search = false;
//                           });
//                         } else {
//                           setState(() {
//                             searchKey = value;
//                             searchKeyLength = searchKey!.length;
//                             search = true;
//                           });
//                         }
//                       },
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: search == false
//                           ? StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance
//                                   .collection("Last Message")
//                                   .doc(userId)
//                                   .collection('Message')
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.separated(
//                                     itemBuilder: (context, index) {
//                                       QueryDocumentSnapshot x =
//                                           snapshot.data!.docs[index];
//                                       if (snapshot.hasData) {
//                                         if (x['Id'] != userId) {
//                                           return ListTile(
//                                             onTap: () {
//                                               FocusScope.of(context).unfocus();
//                                               Navigator.of(context).push(
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           ChatScreen(
//                                                               receiverId:
//                                                                   x['Id'])));
//                                             },
//                                             horizontalTitleGap: 10,
//                                             leading: CircleAvatar(
//                                               radius: 25,
//                                               backgroundImage:
//                                                   NetworkImage(x['Image']),
//                                             ),
//                                             title: Text(x['Name']),
//                                             // subtitle: Text(
//                                             //   x['Last Message'],
//                                             // ),
//                                           );
//                                         } else {
//                                           return SizedBox();
//                                         }
//                                       } else {
//                                         return SizedBox();
//                                       }
//                                     },
//                                     separatorBuilder: (context, index) {
//                                       return SizedBox(
//                                         height: 10,
//                                       );
//                                     },
//                                     itemCount: snapshot.data!.docs.length,
//                                   );
//                                 } else {
//                                   return SizedBox();
//                                 }
//                               },
//                             )
//                           : StreamBuilder<QuerySnapshot>(
//                               stream: FirebaseFirestore.instance
//                                   .collection("Users")
//                                   .snapshots(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   return ListView.separated(
//                                     itemBuilder: (context, index) {
//                                       QueryDocumentSnapshot x =
//                                           snapshot.data!.docs[index];
//                                       if (snapshot.hasData) {
//                                         if (x['Id'] != userId) {
//                                           if (searchKeyLength! <=
//                                               x['Name'].toString().length) {
//                                             if (x['Name'].toString().substring(
//                                                     0, searchKeyLength) ==
//                                                 searchKey) {
//                                               return ListTile(
//                                                 onTap: () {
//                                                   searchController.clear();

//                                                   FocusScope.of(context)
//                                                       .unfocus();
//                                                   Navigator.of(context).push(
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               ChatScreen(
//                                                                   receiverId: x[
//                                                                       'Id'])));
//                                                   setState(() {
//                                                     search = false;
//                                                   });
//                                                 },
//                                                 horizontalTitleGap: 10,
//                                                 leading: CircleAvatar(
//                                                   radius: 25,
//                                                   backgroundImage:
//                                                       NetworkImage(x['Image']),
//                                                 ),
//                                                 title: Text(x['Name']),
//                                                 // subtitle: Text(
//                                                 //   x['Email'],
//                                                 // ),
//                                               );
//                                             } else {
//                                               return SizedBox();
//                                             }
//                                           } else {
//                                             return SizedBox();
//                                           }
//                                         } else {
//                                           return SizedBox();
//                                         }
//                                       } else {
//                                         return SizedBox();
//                                       }
//                                     },
//                                     separatorBuilder: (context, index) {
//                                       return SizedBox(
//                                         height: 5,
//                                       );
//                                     },
//                                     itemCount: snapshot.data!.docs.length,
//                                   );
//                                 } else {
//                                   return SizedBox();
//                                 }
//                               },
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget drawer(BuildContext context) {
//   return SizedBox(
//     width: MediaQuery.of(context).size.width * 0.6,
//     child: Drawer(
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             width: MediaQuery.of(context).size.width,
//             height: 120,
//             color: Colors.purple.shade900,
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Text(
//                 "Developer Contact",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             child: Column(
//               children: [
//                 ListTile(
//                   horizontalTitleGap: 0,
//                   leading: Icon(Icons.phone),
//                   title: Text("+91 9497308477"),
//                 ),
//                 ListTile(
//                   horizontalTitleGap: 0,
//                   leading: Icon(Icons.email),
//                   title: Text("ajaijoseph363@gmail.com"),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
