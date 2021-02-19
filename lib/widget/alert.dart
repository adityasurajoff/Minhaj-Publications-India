import 'package:flutter/material.dart';

customAlert(BuildContext context, String alertText) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    child: Container(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          width: 160,
          decoration: BoxDecoration(color: Colors.white,
              // borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(5, 5),
                    blurRadius: 10),
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(-5, -5),
                    blurRadius: 10)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              Image.asset("asset/logo.png", height: 60, width: 60),
              SizedBox(height: 10),
              Text(alertText == null ? " " : alertText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontFamily: "serif")),
              OutlineButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
