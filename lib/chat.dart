// import 'package:aj_chat/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class ChatScreen extends StatelessWidget {
//   String receiverId;
//   ChatScreen({required this.receiverId});
//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late String receiverImage,
//       receiverName,
//       message,
//       lastMessage,
//       senderName,
//       senderImage;
//   TextEditingController messageController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     firestore
//         .collection("Users")
//         .doc(auth.currentUser!.uid)
//         .get()
//         .then((value) => {
//               senderImage = value.data()!['Image'],
//               senderName = value.data()!['Name'],
//             });
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height / 2,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.all(10),
//               color: Colors.purple.shade900,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   FutureBuilder(
//                     future: FirebaseFirestore.instance
//                         .collection("Users")
//                         .doc(receiverId)
//                         .get()
//                         .then((value) => {
//                               receiverImage = value.data()!['Image'],
//                               receiverName = value.data()!['Name'],
//                             }),
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 20,
//                                   backgroundImage: NetworkImage(receiverImage),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   receiverName,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       } else {
//                         return SizedBox();
//                       }
//                     },
//                   ),
//                   Row(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (context) => HomeScreen()));
//                         },
//                         child: CircleAvatar(
//                           backgroundColor: Colors.white,
//                           child: Icon(
//                             Icons.call,
//                             color: Colors.purple.shade900,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       InkWell(
//                         child: CircleAvatar(
//                           backgroundColor: Colors.white,
//                           child: Icon(
//                             Icons.video_call,
//                             color: Colors.purple.shade900,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.only(top: 10, left: 10, right: 10),
//               margin: EdgeInsets.only(
//                 top: 60,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: StreamBuilder<QuerySnapshot>(
//                       stream: firestore
//                           .collection("Chats")
//                           .doc(auth.currentUser!.uid + receiverId)
//                           .collection("Messages")
//                           .orderBy("Time", descending: true)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return ListView.separated(
//                             reverse: true,
//                             padding: EdgeInsets.all(5),
//                             itemBuilder: (context, index) {
//                               QueryDocumentSnapshot x =
//                                   snapshot.data!.docs[index];
//                               DateTime dateTime = DateTime.parse(x['Time']);
//                               return Row(
//                                 mainAxisAlignment:
//                                     x['SenderId'] == auth.currentUser!.uid
//                                         ? MainAxisAlignment.end
//                                         : MainAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         x['SenderId'] == auth.currentUser!.uid
//                                             ? CrossAxisAlignment.end
//                                             : CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         constraints: BoxConstraints(
//                                             maxWidth: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.6),
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 7, horizontal: 8),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           color: x['SenderId'] ==
//                                                   auth.currentUser!.uid
//                                               ? Colors.purple.shade900
//                                               : Colors.grey.shade300,
//                                         ),
//                                         child: Text(
//                                           x['Message'],
//                                           style: TextStyle(
//                                             color: x['SenderId'] ==
//                                                     auth.currentUser!.uid
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 3,
//                                       ),
//                                       Text(
//                                         " ${DateFormat.jm().format(dateTime)} ",
//                                         style: TextStyle(fontSize: 8),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               );
//                             },
//                             separatorBuilder: (context, index) {
//                               return SizedBox(
//                                 height: 5,
//                               );
//                             },
//                             itemCount: snapshot.data!.docs.length,
//                           );
//                         } else {
//                           return SizedBox();
//                         }
//                       },
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(6),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: messageController,
//                             keyboardType: TextInputType.text,
//                             maxLines: null,
//                             decoration: InputDecoration(
//                               isDense: true,
//                               hintText: "Type your message",
//                               contentPadding:
//                                   EdgeInsets.fromLTRB(10, 10, 10, 10),
//                               fillColor: Colors.white,
//                               filled: true,
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         CircleAvatar(
//                           backgroundColor: Colors.purple.shade900,
//                           radius: 21,
//                           child: IconButton(
//                             onPressed: () {
//                               if (messageController.text.isNotEmpty) {
//                                 sendMessage();
//                               }
//                             },
//                             icon: Icon(Icons.send),
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void sendMessage() async {
//     message = messageController.text;
//     messageController.clear();
//     DateTime date = DateTime.now();

//     await firestore
//         .collection("Chats")
//         .doc(auth.currentUser!.uid + receiverId)
//         .collection("Messages")
//         .add({
//       'Message': message,
//       'Time': date.toString(),
//       'SenderId': auth.currentUser!.uid,
//       'ReceiverId': receiverId,
//     });
//     await firestore
//         .collection("Chats")
//         .doc(receiverId + auth.currentUser!.uid)
//         .collection("Messages")
//         .add({
//       'Message': message,
//       'Time': date.toString(),
//       'SenderId': auth.currentUser!.uid,
//       'ReceiverId': receiverId,
//     });

//     await firestore
//         .collection("Last Message")
//         .doc(auth.currentUser!.uid)
//         .collection("Message")
//         .doc(receiverId)
//         .set({
//       'Last Message': message,
//       'Name': receiverName,
//       'Image': receiverImage,
//       'Id': receiverId,
//     });
//     await firestore
//         .collection("Last Message")
//         .doc(receiverId)
//         .collection("Message")
//         .doc(auth.currentUser!.uid)
//         .set({
//       'Last Message': message,
//       'Name': senderName,
//       'Image': senderImage,
//       'Id': auth.currentUser!.uid,
//     });
//   }
// }
