import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/function/customfunc.dart';
import 'package:minhajpublication/main.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/woocommerce.dart';

class MyOrderScreen extends StatefulWidget {
  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  List _myOrders;
  int _userid;
  bool _isOnline = true;

  _getMyOrders() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userstr = sharedPreferences.getString('userinfo');
    WooCustomer user = WooCustomer.fromJson(jsonDecode(userstr));
    setState(() {
      _userid = user.id;
    });

    try {
      List orderedproducts = await wooCommerce.get('orders');
      // if (_myOrders[index]['customer_id'] == _userid &&
      //     _myOrders[index]['line_items'].length != 0)
      orderedproducts.forEach((element) {
        if (element['customer_id'] == user.id &&
            element['line_items'].length != 0) {
          if (_myOrders == null) {
            _myOrders = [];
          }
          setState(() {
            _myOrders.add(element);
          });
        }
      });
      if (_myOrders == null) {
        setState(() {
          _myOrders = [];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<WooProduct> _getProduct(int id) {
    return wooCommerce.getProductById(id: id);
  }

  @override
  void initState() {
    super.initState();
    checkConnection().then((res) {
      setState(() {
        _isOnline = res;
      });
      if (res) {
        _getMyOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) {
        //           return MinhajApp();
        //         },
        //       ),
        //     );
        //   },
        // ),
        backgroundColor: color_primary,
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: !_isOnline
          ? Text("offline")
          : _myOrders == null
              ? SpinKitRipple(color: color_primary)
              : _myOrders.length == 0
                  ? Container(
                      width: size.width,
                      color: color_primary.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("asset/logo.png", height: 180),
                          SizedBox(height: 8),
                          Text(
                            "You haven't ordered any item yet...",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: color_primary,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: size.height + 12,
                      width: size.width,
                      color: Colors.grey.withOpacity(0.1),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _myOrders.length,
                              itemBuilder: (context, index) {
                                if (_myOrders[index]['customer_id'] ==
                                        _userid &&
                                    _myOrders[index]['line_items'].length !=
                                        0) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 6),
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Container(
                                        //   color: Colors.white,
                                        //   padding: EdgeInsets.symmetric(
                                        //       horizontal: 6, vertical: 3),
                                        //   child: Text(
                                        //       "Status: " +
                                        //           _myOrders[index]['status'].toString(),
                                        //       style: TextStyle(
                                        //           color: color_primary,
                                        //           fontWeight: FontWeight.bold)),
                                        // ),
                                        Wrap(
                                            children: List.from(_myOrders[index]
                                                    ['line_items'])
                                                .map((e) {
                                          return FutureBuilder(
                                              future:
                                                  _getProduct(e['product_id']),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  WooProduct product =
                                                      snapshot.data;
                                                  return InkWell(
                                                    onTap: () {
                                                      // Navigator.of(context).push(
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) {
                                                      //   return ProductScreen(
                                                      //       e['product_id']
                                                      //           .toString());
                                                      // }));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      width: size.width,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            height: 100,
                                                            width: 90,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              child:
                                                                  customNetworkImageLoading(
                                                                product
                                                                    .images[0]
                                                                    .src,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                          Container(
                                                            width: size.width -
                                                                130,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  product.name,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    // color: Colors
                                                                    //     .white,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  // color: Colors
                                                                  //     .white
                                                                  //     .withOpacity(
                                                                  //         0.3),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4,
                                                                          vertical:
                                                                              2),
                                                                  child: Text(
                                                                    "Price: ₹" +
                                                                        e['total']
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      // color: Colors
                                                                      //     .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  // color: Colors
                                                                  //     .white
                                                                  //     .withOpacity(
                                                                  //         0.3),
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              4,
                                                                          vertical:
                                                                              2),
                                                                  child: Text(
                                                                    "Quantity: " +
                                                                        e['quantity']
                                                                            .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      // color: Colors
                                                                      //     .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return SpinKitRipple(
                                                    color: color_primary,
                                                  );
                                                }
                                              });
                                        }).toList()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: color_primary,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 3),
                                              child: Text(
                                                  "Status: " +
                                                      _myOrders[index]['status']
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  )),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: color_primary,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 3),
                                              child: Text(
                                                "Ordered: " +
                                                    dateParser(_myOrders[index]
                                                            ['date_created']
                                                        .toString()),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: _myOrders[index]['status'] !=
                                                  "pending"
                                              ? SizedBox.shrink()
                                              : IconButton(
                                                  tooltip: "Cancel Order",
                                                  icon: Icon(
                                                      Icons
                                                          .remove_shopping_cart,
                                                      color: Colors.grey),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: (context),
                                                      child: AlertDialog(
                                                        title: Text("HomeMozo"),
                                                        content: Text(
                                                            "Cancel Order"),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text("No")),
                                                          FlatButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              customLoader(
                                                                  context);
                                                              Future.delayed(
                                                                      Duration(
                                                                          seconds:
                                                                              2))
                                                                  .then((v) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return MyOrderScreen();
                                                                    },
                                                                  ),
                                                                );
                                                              });

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              var del = await wooCommerce
                                                                  .deleteOrder(
                                                                      orderId: _myOrders[
                                                                              index]
                                                                          [
                                                                          'id']);
                                                            },
                                                            child: Text("Yes"),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
