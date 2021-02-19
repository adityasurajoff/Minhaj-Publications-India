import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/checkout.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:provider/provider.dart';

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  // List<WooCartItem> _cartItem;
  int _total = 0;

  _getMyCartItems() {
    wooCommerce.getMyCartItems().then((res) {
      print(res);
      Provider.of<AppState>(context, listen: false).setCartItems(res);
      Provider.of<AppState>(context, listen: false)
          .setCartItemCount(res.length);
      Provider.of<AppState>(context, listen: false)
          .setCartItemCount(res.length);
    }).then((res) {
      print(res);
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
    });
  }

  @override
  void initState() {
    super.initState();
    _getMyCartItems();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AppState>(
      builder: (context, hstate, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: color_primary,
            title: Text(
              'MyCart',
              style: TextStyle(color: Colors.white),
            ),
          ),
          drawer: CustomDrawer(),
          body: hstate.cartItems == null
              ? Container(
                  height: size.height,
                  width: size.width,
                  color: color_primary.withOpacity(0.1),
                  child: SpinKitRipple(
                    color: color_primary,
                  ),
                )
              : hstate.cartItems.length == 0
                  ? Container(
                      height: size.height,
                      width: size.width,
                      color: color_primary.withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/logo.png',
                            height: 140,
                          ),
                          Text(
                            'Your cart is empty...',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
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
                            bottom: 64,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: hstate.cartItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
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
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
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
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () async {
                                                      customLoader(context);
                                                      wooCommerce
                                                          .deleteMyCartItem(
                                                        key: hstate
                                                            .cartItems[index]
                                                            .key,
                                                      )
                                                          .then((res) {
                                                        _getMyCartItems();
                                                        Navigator.of(context)
                                                            .pop();
                                                        hstate
                                                            .decrementCartItemCount();
                                                      });
                                                    },
                                                  )
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
                              height: 54,
                              width: size.width,
                              padding: EdgeInsets.only(
                                  top: 6, left: 12, right: 12, bottom: 6),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                color: color_primary.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _total == 0
                                      ? SpinKitPouringHourglass(
                                          color: color_primary,
                                          size: 24,
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Proceed To Checkout",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "${hstate.cartItemCount} Items in Cart",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return CheckoutScreen();
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: color_primary,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Checkout",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
