import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';

Future customLoader(BuildContext context, {String txt}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SpinKitWave(color: color_primary),
                SpinKitRipple(
                  color: color_primary,
                ),
                // SpinKitFadingCube(color: Colors.black),
                SizedBox(height: 20),
                Text(
                  txt == null ? "Processing" : txt,
                  style: TextStyle(
                    fontFamily: "arial",
                    fontSize: 14,
                    color: color_primary,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
