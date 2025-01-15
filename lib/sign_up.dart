import 'dart:io';

import 'package:aj_chat_node/auth_service/auth_service.dart';
import 'package:aj_chat_node/common_loading.dart';
import 'package:aj_chat_node/login.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  File? image;

  var imgUrl;
  Map map = {};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height,
              color: Colors.purple.shade900,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              margin: EdgeInsets.only(
                top: 60,
              ),
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) => bottomSheet());
                        },
                        child: CircleAvatar(
                          backgroundImage: image == null
                              ? AssetImage("assets/images/pic.png")
                              : FileImage(File(image!.path)) as ImageProvider,
                          radius: 70,
                        ),
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Name"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter Name";
                        },
                        // onSaved: (value) {
                        //   email = value!;
                        // },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter Email";
                        },
                        // onSaved: (value) {
                        //   email = value!;
                        // },
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: "Password"),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) return "Enter Password";
                        },
                        // onSaved: (value) {
                        //   password = value!;
                        // },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (image != null) {
                              commonLoading(context);
                              registerUser(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please upload your photo");
                            }
                          }
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser(context) async {
    bool success = await AuthService().registerUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profileImage: image!);
    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    } else {
      Fluttertoast.showToast(msg: "Registration failed");
      Navigator.of(context).pop();
    }
  }

  Future<void> takePhoto(ImageSource source) async {
    XFile? img = await ImagePicker().pickImage(source: source);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  Widget bottomSheet() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Choose profile photo"),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }
}
