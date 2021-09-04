import 'package:flutter/material.dart';

Widget buildErrorWidget() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Check your internet connection or some error on system",
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}
