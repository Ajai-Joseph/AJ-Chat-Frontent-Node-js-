// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class ResetPassword extends StatelessWidget {
//   ResetPassword({Key? key}) : super(key: key);
//   TextEditingController emailController = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.all(15),
//               height: MediaQuery.of(context).size.height,
//               color: Colors.purple.shade900,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Reset Password",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               margin: EdgeInsets.only(
//                 top: 60,
//                 // left: 10,
//                 // right: 10,
//               ),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: emailController,
//                     decoration: InputDecoration(labelText: "Email"),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value!.isEmpty) return "Enter Email";
//                     },
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (emailController.text.isNotEmpty) {
//                         auth
//                             .sendPasswordResetEmail(email: emailController.text)
//                             .then((value) => {
//                                   Fluttertoast.showToast(
//                                       msg:
//                                           "Verification Email send Successfully")
//                                 })
//                             .then((value) => {Navigator.of(context).pop()});
//                       } else {
//                         Fluttertoast.showToast(msg: "Please enter your email");
//                       }
//                     },
//                     child: Text(
//                       "Send Request",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.red,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40),
//                       ),
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
// }
