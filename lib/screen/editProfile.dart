import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/main.dart';
import 'package:minhajpublication/widget/alert.dart';
import 'package:minhajpublication/widget/customTextField.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/woocommerce.dart';

class EditMyProfilecreen extends StatefulWidget {
  @override
  _EditMyProfilecreenState createState() => _EditMyProfilecreenState();
}

class _EditMyProfilecreenState extends State<EditMyProfilecreen> {
  TextEditingController _phone = TextEditingController(),
      _address = TextEditingController(),
      _city = TextEditingController(),
      _state = TextEditingController(),
      _pincode = TextEditingController();

  _getPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userinfo = sharedPreferences.getString("userinfo");
    Map json = jsonDecode(userinfo);
    WooCustomer user = WooCustomer.fromJson(json);
    setState(() {
      _city.text = user.shipping.city;
      _pincode.text = user.shipping.postcode;
      _phone.text = user.metaData[0].value;
      _state.text = user.shipping.state;
      _address.text = user.shipping.address1;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        title: Text(
          "Update My Account",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: color_primary),
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              CustomTextField(
                prefixIcon: Icons.phone,
                label: "Phone Number",
                inputType: TextInputType.phone,
                maxlength: 10,
                controller: _phone,
              ),
              CustomTextField(
                prefixIcon: Icons.home,
                label: "Address",
                maxLines: 3,
                controller: _address,
              ),
              CustomTextField(
                prefixIcon: Icons.location_city,
                label: "City",
                controller: _city,
              ),
              CustomTextField(
                prefixIcon: Icons.location_city,
                label: "State",
                controller: _state,
              ),
              CustomTextField(
                prefixIcon: Icons.pin_drop,
                label: "Pincode",
                controller: _pincode,
                inputType: TextInputType.number,
                maxlength: 6,
              ),
              RaisedButton(
                color: Colors.white,
                child: Text("Update"),
                onPressed: () async {
                  if (_phone.text == "" ||
                      _address.text == "" ||
                      _city.text == "" ||
                      _state.text == "" ||
                      _pincode.text == "") {
                    customAlert(context, "All fields required...");
                  } else if (_phone.text.length < 10 ||
                      _phone.text.startsWith(RegExp(r'[0-4]'))) {
                    customAlert(context, "Invalid phone number...");
                  } else {
                    customLoader(context);
                    // WooCommerce woo = WooCommerce(
                    //   baseUrl: rootlink,
                    //   consumerKey: consumer_key,
                    //   consumerSecret: consumer_secret,
                    // );
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    Map json =
                        jsonDecode(sharedPreferences.getString("userinfo"));
                    WooCustomer user = WooCustomer.fromJson(json);
                    user.metaData = [
                      WooCustomerMetaData(1, "phonenumber", _phone.text)
                    ];
                    user.billing.firstName = user.firstName;
                    user.billing.lastName = user.lastName;
                    user.billing.email = user.email;
                    user.billing.phone = _phone.text;
                    user.billing.address1 = _address.text;
                    user.billing.postcode = _pincode.text;
                    user.billing.city = _city.text;
                    user.billing.state = _state.text;
                    user.shipping.address1 = _address.text;
                    user.shipping.postcode = _pincode.text;
                    user.shipping.city = _city.text;
                    user.shipping.state = _state.text;
                    wooCommerce
                        .oldUpdateCustomer(wooCustomer: user)
                        .then((res) {
                      Navigator.of(context).pop();
                      sharedPreferences.setString("userinfo", jsonEncode(res));
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return MinhajApp();
                      }));
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
