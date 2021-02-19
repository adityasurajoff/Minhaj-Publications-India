import 'package:flutter/material.dart';
import 'package:minhajpublication/screen/categoryProducts.dart';

Widget circularCategory(BuildContext context,
    {String name, String image, String id}) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return CategoryProductScreen(id);
          },
        ),
      );
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              image == null ? AssetImage('asset/logo.png') : AssetImage(image),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          name == null ? "Name" : name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
