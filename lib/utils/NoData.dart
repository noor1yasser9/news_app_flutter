import 'package:flutter/material.dart';

Widget buildNoDataWidget(String error, context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(color: Colors.black45),
            )
          ],
        )
      ],
    ),
  );
}
