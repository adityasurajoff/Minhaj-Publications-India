import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/myorders.dart';
import 'package:minhajpublication/widget/alert.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:minhajpublication/widget/loading.dart';
// import 'package:payu_money_flutter/payu_money_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/models/order_payload.dart';
import 'package:woocommerce/woocommerce.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const platform = const MethodChannel("razorpay_flutter");
  // Razorpay _razorpay = Razorpay();
  int _total = 0;
  // PayuMoneyFlutter payuMoneyFlutter = PayuMoneyFlutter();

  // setupPayment() async {
  //   bool response = await payuMoneyFlutter.setupPaymentKeys(
  //     merchantKey: "0ehXjEqh",
  //     merchantID: "iaexdVtD4r",
  //     isProduction: false,
  //     activityTitle: "Minhaj Publications India",
  //     disableExitConfirmation: false,
  //   );
  // }

  _getMyCartItems() {
    wooCommerce.getProductShippingClasses().then((value) {
      print(value);
      setState(() {});
    });
    if (Provider.of<AppState>(context, listen: false).cartItems == null) {
      wooCommerce.getMyCartItems().then((res) {
        Provider.of<AppState>(context, listen: false).setCartItems(res);
        Provider.of<AppState>(context, listen: false)
            .setCartItemCount(res.length);
      });
    }
    if (Provider.of<AppState>(context, listen: false).cartItems != null &&
        Provider.of<AppState>(context, listen: false).cartItems.length != 0) {
      setState(() {
        _total = 0;
      });
      Provider.of<AppState>(context, listen: false)
          .cartItems
          .forEach((element) {
        setState(() {
          _total += double.parse(element.price).ceil() * element.quantity;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getMyCartItems();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _sucessHandler);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _errhandler);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _extwallet);
    // setupPayment();
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  // void _sucessHandler(PaymentSuccessResponse response) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   WooCustomer customer = WooCustomer.fromJson(
  //     jsonDecode(
  //       sharedPreferences.getString('userinfo'),
  //     ),
  //   );
  //   String phone = customer.metaData[2].value.toString();
  //   String email = customer.email;
  //   String productName = "Minhaj Publications India Books";
  //   String firstName = customer.firstName;
  //   String txnID = "46987fasd";
  //   String amount = "$_total";
  //   wooCommerce
  //       .createOrder(WooOrderPayload(
  //     lineItems: Provider.of<AppState>(context, listen: false).cartItems.map(
  //       (item) {
  //         return LineItems(
  //           productId: item.id,
  //           name: "${item.name}",
  //           quantity: item.quantity,
  //           total: "${(double.parse(item.price) * item.quantity)}",
  //           subtotal: "${(double.parse(item.price))}",
  //         );
  //       },
  //     ).toList(),
  //     currency: "INR",
  //     paymentMethod: "razorpay",
  //     setPaid: true,
  //     status: 'processing',
  //     customerId: customer.id,
  //     paymentMethodTitle: "Paid via Razorpay",
  //     shipping: WooOrderPayloadShipping(
  //       firstName: customer.firstName,
  //       lastName: customer.lastName,
  //       address1: customer.shipping.address1,
  //       city: customer.shipping.city,
  //       state: customer.shipping.state,
  //       postcode: customer.shipping.postcode,
  //     ),
  //     metaData: [
  //       WooOrderPayloadMetaData(
  //         key: "phonenumber",
  //         value: phone.toString(),
  //       )
  //     ],
  //   ))
  //       .then(
  //     (res) async {
  //       Navigator.of(context).pop();
  //       customAlert(
  //         context,
  //         "Order placed successfully...",
  //       ).then(
  //         (v) {
  //           wooCommerce.deleteAllMyCartItems();
  //           Provider.of<AppState>(context, listen: false).setCartItemCount(0);
  //           Provider.of<AppState>(context, listen: false).setCartItems(null);
  //           Navigator.of(context).pop();
  //           Navigator.of(context).pushAndRemoveUntil(
  //               MaterialPageRoute(builder: (context) {
  //             return MyOrderScreen();
  //           }), (route) => false);
  //         },
  //       );
  //     },
  //   );
  // }

  // void _errhandler(PaymentFailureResponse response) {
  //   // print(response.message + '  ' + response.code.toString());
  //   customAlert(context, response.message);
  // }

  // void _extwallet(ExternalWalletResponse response) {
  //   print(response.walletName + '  ' + response.walletName);
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    Size size = MediaQuery.of(context).size;
    return Consumer<AppState>(
      builder: (context, hstate, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            elevation: 0,
            backgroundColor: color_primary,
            title: Text(
              'Checkout',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: hstate.cartItems == null
              ? SpinKitRipple(
                  color: color_primary,
                )
              : hstate.cartItems.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('asset/emptycart.png'),
                        Text(
                          'Your cart is empty...',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  : Container(
                      height: size.height,
                      width: size.width,
                      color: color_primary.withOpacity(0.1),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 110,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: hstate.cartItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 106,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          child: customNetworkImageLoading(
                                            hstate
                                                .cartItems[index].images[0].src,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        height: 106,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: size.width - 120 - 24,
                                              child: Text(
                                                hstate.cartItems[index].name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: size.width - 120 - 24,
                                              child: Text(
                                                "Quantity: " +
                                                    hstate.cartItems[index]
                                                        .quantity
                                                        .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: size.width - 120 - 24,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Chip(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    label: Text(
                                                      "₹${hstate.cartItems[index].price}",
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 110,
                              width: size.width,
                              padding: EdgeInsets.only(
                                  top: 8, left: 12, right: 12, bottom: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                // color: color_primary.withOpacity(0.5),
                                gradient: grad_one,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.symmetric(vertical: 4),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(
                                  //         "Shipping Charge",
                                  //         style: TextStyle(
                                  //           fontSize: 17,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       Text(
                                  //         "611",
                                  //         style: TextStyle(
                                  //           fontSize: 17,
                                  //           color: Colors.white,
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.symmetric(vertical: 4),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(
                                  //         "Cart Discount",
                                  //         style: TextStyle(
                                  //           fontSize: 17,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       Text(
                                  //         "611",
                                  //         style: TextStyle(
                                  //           fontSize: 17,
                                  //           color: Colors.white,
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total: ₹$_total",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          // customLoader(context);
                                          SharedPreferences sharedPreferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          WooCustomer customer =
                                              WooCustomer.fromJson(
                                            jsonDecode(
                                              sharedPreferences
                                                  .getString('userinfo'),
                                            ),
                                          );
                                          String phone = customer
                                              .metaData[2].value
                                              .toString();

                                          // String amount = "$_total";
                                          // wooCommerce
                                          //     .createOrder(WooOrderPayload(
                                          //   lineItems: hstate.cartItems.map(
                                          //     (item) {
                                          //       return LineItems(
                                          //         productId: item.id,
                                          //         name: "${item.name}",
                                          //         quantity: item.quantity,
                                          //         total:
                                          //             "${(double.parse(item.price) * item.quantity)}",
                                          //         subtotal:
                                          //             "${(double.parse(item.price))}",
                                          //       );
                                          //     },
                                          //   ).toList(),
                                          //   currency: "INR",
                                          //   paymentMethod: "payubolt",
                                          //   setPaid: false,
                                          //   status: 'processing',
                                          //   customerId: customer.id,
                                          //   paymentMethodTitle:
                                          //       "Paid via PayUmoney",
                                          //   shipping: WooOrderPayloadShipping(
                                          //     firstName: customer.firstName,
                                          //     lastName: customer.lastName,
                                          //     address1:
                                          //         customer.shipping.address1,
                                          //     city: customer.shipping.city,
                                          //     state: customer.shipping.state,
                                          //     postcode:
                                          //         customer.shipping.postcode,
                                          //   ),
                                          //   metaData: [
                                          //     WooOrderPayloadMetaData(
                                          //       key: "phonenumber",
                                          //       value: phone.toString(),
                                          //     )
                                          //   ],
                                          // ))
                                          //     .then(
                                          //   (res) async {
                                          //     Navigator.of(context).pop();
                                          //     customAlert(
                                          //       context,
                                          //       "Order placed successfully...",
                                          //     ).then(
                                          //       (v) {
                                          //         wooCommerce
                                          //             .deleteAllMyCartItems();
                                          //         hstate.setCartItemCount(0);
                                          //         hstate.setCartItems(null);
                                          //         Navigator.of(context).pop();
                                          //         Navigator.of(context)
                                          //             .pushReplacement(
                                          //           MaterialPageRoute(
                                          //             builder: (context) {
                                          //               return MyOrderScreen();
                                          //             },
                                          //           ),
                                          //         );
                                          //       },
                                          //     );
                                          //   },
                                          // );

                                          void openCheckout() async {
                                            var options = {
                                              // 'key': 'rzp_live_PM2jOwOInyyE5D',
                                              'key': 'rzp_live_neU9ptZu2CbOEK',
                                              'amount': _total * 100,
                                              'name': 'Minhaj Publications',
                                              'description': 'Purchase Amount',
                                              'theme': {
                                                'hide_topbar': false,
                                                'color': '#65ca00',
                                                'backdrop_color': '#65ca00'
                                              },
                                              'image':
                                                  'http://minhajpublicationsindia.com/wp-content/uploads/2020/07/Logo_small.png',
                                              'prefill': {
                                                'contact': phone.toString(),
                                                'name': customer.firstName +
                                                    " " +
                                                    customer.lastName,
                                                'email':
                                                    customer.email.toString(),
                                              },
                                              'external': {
                                                'wallets': ['paytm']
                                              }
                                            };
                                            try {
                                              // _razorpay.open(options);
                                            } catch (e) {
                                              debugPrint(e);
                                            }
                                          }

                                          openCheckout();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Place Order",
                                              style: TextStyle(
                                                color: color_primary,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Positioned(
                          //   child: Container(
                          //     color: Colors.white,
                          //     child: Text("${hstate.cartItems.first.price}"),
                          //   ),
                          // )
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
