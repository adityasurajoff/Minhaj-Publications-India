import 'dart:convert';
import 'dart:io';

import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/main.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/auth/login.dart';
import 'package:minhajpublication/widget/alert.dart';
import 'package:minhajpublication/widget/customTextField.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/woocommerce.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _email = TextEditingController(),
      _password = TextEditingController(),
      _fname = TextEditingController(),
      _lname = TextEditingController(),
      _phone = TextEditingController(),
      _username = TextEditingController(),
      _confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(gradient: grad_one),
        child: Stack(
          children: [
            Positioned(
              top: -90,
              right: 0,
              left: -140,
              child: Container(
                transform: Matrix4.rotationZ(-0.30),
                width: size.width,
                height: 240,
                color: Colors.lightGreenAccent,
              ),
            ),
            Positioned(
              top: -300,
              right: -120,
              left: -190,
              child: Container(
                  transform: Matrix4.rotationZ(0.30),
                  width: size.width,
                  height: 240,
                  color: Colors.lightGreen),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 120),
                // height: size.height - 120 + 86,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'asset/logo.png',
                            height: 100,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Minhaj Publications\nIndia",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 34,

                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: "serif",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      CustomTextField(
                        label: "First Name",
                        prefixIcon: Icons.person,
                        controller: _fname,
                      ),
                      CustomTextField(
                        label: "Last Name",
                        prefixIcon: Icons.text_format,
                        controller: _lname,
                      ),
                      CustomTextField(
                        label: "Username",
                        prefixIcon: Icons.verified_user,
                        controller: _username,
                      ),
                      CustomTextField(
                        label: "Email",
                        prefixIcon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        controller: _email,
                      ),
                      CustomTextField(
                        label: "Phone",
                        prefixIcon: Icons.phone,
                        inputType: TextInputType.phone,
                        controller: _phone,
                        maxlength: 10,
                      ),
                      CustomTextField(
                        label: "Password",
                        prefixIcon: Icons.lock,
                        controller: _password,
                        isobsecure: true,
                      ),
                      RaisedButton(
                        color: Colors.white,
                        child: Text(
                          "Create Account",
                          style: TextStyle(color: color_primary),
                        ),
                        onPressed: () async {
                          // customLoader(context);
                          // wooCommerce
                          //     .createCustomer(
                          //   WooCustomer(
                          //       dateCreated: DateTime.now().toString(),
                          //       firstName: _fname.text,
                          //       lastName: _lname.text,
                          //       username: _username.text,
                          //       email: _email.text,
                          //       password: _password.text,
                          //       isPayingCustomer: true,
                          //       role: "Customer",
                          //       metaData: [
                          //         WooCustomerMetaData(1, "phonenumber", _phone.text)
                          //       ]
                          //       // billing: Billing(),
                          //       // shipping: Shipping(),
                          //       ),
                          // )
                          //     .then((res) {
                          //   Navigator.of(context).pop();
                          //   print(res);
                          // });

                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          if (_email.text == "" ||
                              _phone.text == "" ||
                              _fname.text == "" ||
                              _lname.text == "" ||
                              _username.text == "" ||
                              _password.text == "") {
                            customAlert(context, "All Fields Required");
                          } else if (_phone.text.length < 10 ||
                              _phone.text.startsWith(RegExp(r'[0-4]'))) {
                            customAlert(context, "Invalid phone number...");
                          } else {
                            customLoader(context, txt: "Creating\nAccount");

                            wooCommerce
                                .createCustomer(
                              WooCustomer(
                                  dateCreated: DateTime.now().toString(),
                                  firstName: _fname.text,
                                  lastName: _lname.text,
                                  username: _username.text,
                                  email: _email.text,
                                  password: _password.text,
                                  isPayingCustomer: true,
                                  role: "Customer",
                                  metaData: [
                                    WooCustomerMetaData(
                                        1, "phonenumber", _phone.text)
                                  ]
                                  // billing: Billing(),
                                  // shipping: Shipping(),
                                  ),
                            )
                                .then((val) {
                              Navigator.of(context).pop();
                              customLoader(context, txt: "Validating...");
                              wooCommerce
                                  .loginCustomer(
                                      username: _email.text,
                                      password: _password.text)
                                  .then((res) {
                                Navigator.of(context).pop();
                                print(res);
                                try {
                                  sharedPreferences.setString(
                                      "userinfo", jsonEncode(res));
                                  WooCustomer userinfo = res;
                                  sharedPreferences.setBool("islogined", true);
                                  Provider.of<AppState>(context, listen: false)
                                      .setCustomer(userinfo);
                                  Provider.of<AppState>(context, listen: false)
                                      .setIsLogined(true);

                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                    return MinhajApp();
                                  }), (route) => false);
                                } catch (e) {
                                  customAlert(context, res);
                                }
                              });
                            }, onError: (err) {
                              Navigator.of(context).pop();
                              customAlert(
                                  context, "Username or Email already exists");
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Have Account ? Login here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
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
}
