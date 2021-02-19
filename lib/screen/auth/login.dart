import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/main.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/auth/signup.dart';
import 'package:minhajpublication/widget/alert.dart';
import 'package:minhajpublication/widget/customTextField.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woocommerce/models/customer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController(),
      _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height - 27,
            width: size.width,
            decoration: BoxDecoration(gradient: grad_one),
            child: Stack(
              children: <Widget>[
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
                    color: Colors.green.withOpacity(0.6),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: size.height,
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "asset/logo.png",
                              height: 80,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Minhaj Publications\nIndia",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 12,
                        // ),
                        Text(
                          "Customer Login",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        CustomTextField(
                          label: "Email or Username",
                          prefixIcon: Icons.email,
                          controller: _email,
                          inputType: TextInputType.emailAddress,
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
                            "Login",
                            style: TextStyle(color: color_primary),
                          ),
                          onPressed: () async {
                            // WooCommerce woo = WooCommerce(
                            //     baseUrl: rootlink,
                            //     consumerKey: consumer_key,
                            //     consumerSecret: consumer_secret);
                            // print(await woo.fetchLoggedInUserId());
                            // await woo
                            //     .loginCustomer(
                            //   username: _email.text,
                            //   password: _password.text,
                            // )
                            //     .then((res) {
                            //   // print();
                            //   // Navigator.of(context).pop();
                            // });

                            // wooCommerce
                            //     .loginCustomer(
                            //         username: _email.text,
                            //         password: _password.text)
                            //     .then((res) {
                            //   Navigator.of(context).pop();
                            //   // print(res);
                            // });
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            if (_email.text == "") {
                              customAlert(context, "Empty username!");
                            } else if (_password.text == "") {
                              customAlert(context, "Empty password!");
                            } else {
                              customLoader(context, txt: "Validating");

                              wooCommerce
                                  .loginCustomer(
                                      username: _email.text,
                                      password: _password.text)
                                  .then((res) {
                                Navigator.of(context).pop();
                                if (res.toString() ==
                                    "Unknown username. Check again or try your email address.") {
                                  customAlert(context, res.toString());
                                } else if (res.toString() ==
                                    "Unknown email address. Check again or try your username.") {
                                  customAlert(context, res.toString());
                                } else if (res
                                    .toString()
                                    .startsWith('<strong>')) {
                                  showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text("HomeMozo"),
                                        content: Html(
                                          data: res.toString(),
                                          onLinkTap: (e) {
                                            if (canLaunch(e) != null) {
                                              launch(e);
                                            }
                                          },
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Ok"),
                                          )
                                        ],
                                      ));
                                } else {
                                  try {
                                    sharedPreferences.setString(
                                        "userinfo", jsonEncode(res));
                                    sharedPreferences.setBool(
                                        "islogined", true);
                                    WooCustomer userinfo = res;
                                    Provider.of<AppState>(context,
                                            listen: false)
                                        .setCustomer(userinfo);
                                    Provider.of<AppState>(context,
                                            listen: false)
                                        .setIsLogined(true);
                                    // Navigator.of(context).pushReplacement(
                                    //     MaterialPageRoute(builder: (context) {
                                    //   return MinhajApp();
                                    // }));
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                        return MinhajApp();
                                      }),
                                      (route) => false,
                                    );
                                  } catch (e) {
                                    customAlert(context, res.toString());
                                  }
                                }
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
                                MaterialPageRoute(builder: (context) {
                              return SignupScreen();
                            }));
                          },
                          child: Text(
                            "New User ? Register here",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
