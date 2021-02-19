import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/auth/login.dart';
import 'package:minhajpublication/screen/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/models/customer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: color_primary,
      statusBarColor: color_primary,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: color_primary),
        home: MinhajApp(),
      ),
    ),
  );
}

class MinhajApp extends StatefulWidget {
  @override
  _MinhajAppState createState() => _MinhajAppState();
}

class _MinhajAppState extends State<MinhajApp> {
  _getLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.remove('token');
    // sharedPreferences.remove('islogined');
    if (sharedPreferences.getBool('islogined')) {
      Provider.of<AppState>(context, listen: false).setIsLogined(true);
    }
    Provider.of<AppState>(context, listen: false).setCustomer(
      WooCustomer.fromJson(
        jsonDecode(
          sharedPreferences.getString('userinfo'),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AppState>(
        builder: (context, astate, child) {
          return Scaffold(
            body: astate.islogined ? HomePage() : LoginScreen(),
          );
        },
      ),
    );
  }
}
