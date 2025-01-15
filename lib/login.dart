import 'dart:convert';

import 'package:aj_chat_node/auth_service/auth_service.dart';
import 'package:aj_chat_node/common_loading.dart';
import 'package:aj_chat_node/home_screen.dart';
import 'package:aj_chat_node/main.dart';
import 'package:aj_chat_node/sign_up.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height,
                color: Colors.purple.shade900,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AJ Chat",
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
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 150,
                  left: 15,
                  right: 15,
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) return "Enter Email";
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: "Password"),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) return "Enter Password";
                          },
                          // onSaved: (value) => password = value!,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  signIn(context);
                                }
                              },
                              child: Text(
                                "Sign in",
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
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
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
                        TextButton(
                          onPressed: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ResetPassword()));
                          },
                          child: Text("Forgot Password?"),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.purple.shade900),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    try {
      commonLoading(context);
      var response = await AuthService().loginUser(
        email: emailController.text,
        password: passwordController.text,
      );
      if (response != null) {
        SharedPreferences sharedPreference =
            await SharedPreferences.getInstance();
        await sharedPreference.setString(
            currentlyLoggedInUserSaveKey, jsonEncode(response));
        currentlyLoggedInUserDetailsMap = response;
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: "Login Failed");
        Navigator.of(context).pop();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Login Failed");
      Navigator.of(context).pop();
    }
  }
}
