import 'package:flutter/material.dart';

commonLoading(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text(
            "Please wait...",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      );
    },
  );
}
