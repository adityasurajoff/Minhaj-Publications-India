import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/product.dart';
import 'package:minhajpublication/widget/alert.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WooProduct> _products;
  TextEditingController _search = TextEditingController();
  ScrollController _listScrollContoller = ScrollController();
  bool _isLazyLoading = false;
  int _pageNumToLoad = 1;
  bool _isSearching = false;

  _getProducts(String search) async {
    setState(() {
      _isSearching = true;
    });
    wooCommerce
        .getProducts(page: _pageNumToLoad, perPage: 6, search: search)
        .then((res) {
      print(res);
      setState(() {
        _isSearching = false;
        _products = res;
      });
    });
  }

  _getLazyProducts(String search) async {
    List<WooProduct> lazyProducts = await wooCommerce.getProducts(
        page: (_pageNumToLoad + 1), perPage: 6, search: search);
    List<WooProduct> initialProducts = _products;
    lazyProducts.forEach((element) {
      initialProducts.add(element);
    });
    setState(() {
      _pageNumToLoad = _pageNumToLoad + 1;
      _products = initialProducts;
      _isLazyLoading = false;
    });
  }

  _lazyLoading() {
    _listScrollContoller.addListener(() {
      if (_listScrollContoller.position.maxScrollExtent ==
              _listScrollContoller.offset ||
          _products.length != 0) {
        setState(() {
          _isLazyLoading = true;
        });
        _getLazyProducts(_search.text);
      } else {
        setState(() {
          _isLazyLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _getProducts(_search.text);
    _lazyLoading();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
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
        //     Navigator.of(context).pop();
        //   },
        // ),
        backgroundColor: color_primary,
        elevation: 0,
        title: Container(
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _search,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search",
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                print(_search.text);
                setState(() {
                  // _products = null;
                  _isSearching = true;
                });
                _getProducts(_search.text);
              })
        ],
      ),
      body: _products == null
          ? Container(
              height: size.height,
              width: size.width,
              color: color_primary.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "asset/logo.png",
                    height: 140,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Search For Books you are looking for",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: color_primary),
                  )
                ],
              ),
            )
          : _products.length == 0
              ? Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/logo.png',
                        height: 180,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Book you are looking isn't available...",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              : _isSearching
                  ? SpinKitRipple(color: color_primary)
                  : Container(
                      color: Colors.grey.withOpacity(0.1),
                      child: ListView.builder(
                        controller: _listScrollContoller,
                        itemCount: _isLazyLoading
                            ? _products.length + 1
                            : _products.length,
                        itemBuilder: (context, index) {
                          if (index == _products.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SpinKitThreeBounce(
                                color: color_primary,
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (context) {
                                //   return ProductScreen(
                                //       _products[index].id.toString());
                                // }));
                              },
                              child: _products[index].name == "Wallet Topup"
                                  ? SizedBox.shrink()
                                  : InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ProductScreen(
                                                  _products[index]
                                                      .id
                                                      .toString());
                                            },
                                          ),
                                        );
                                      },
                                      child: longWidthProductCard(
                                        size,
                                        img: _products[index].images.length == 0
                                            ? null
                                            : _products[index].images[0].src,
                                        productName: _products[index].name,
                                        regularPrice:
                                            _products[index].regularPrice,
                                        sku: _products[index].sku,
                                        salePrice: _products[index].salePrice,
                                        productId:
                                            _products[index].id.toString(),
                                        purchaseable:
                                            _products[index].purchasable,
                                        context: context,
                                      ),
                                    ),
                            );
                          }
                        },
                      ),
                    ),
    );
  }
}

Widget longWidthProductCard(
  Size size, {
  String img,
  String productName,
  String sku,
  String regularPrice,
  String salePrice,
  String productId,
  bool purchaseable,
  BuildContext context,
}) {
  return Container(
    width: size.width,
    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1.6),
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      // gradient: grad_one,
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 120,
          width: 140,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: customNetworkImageLoading(
              img,
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Container(
          // padding: EdgeInsets.symmetric(vertical: 8),
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width - 140 - 24,
                child: Text(
                  productName.replaceAll("&amp;", "&"),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Container(
              //   child: Text(
              //     sku,
              //     maxLines: 2,
              //     overflow: TextOverflow.ellipsis,
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Colors.white,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
              Spacer(),
              Container(
                width: size.width - 140 - 24,
                margin: EdgeInsets.symmetric(vertical: 2),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "₹$regularPrice",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text(
                    //   "₹$regularPrice",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //     decoration: TextDecoration.lineThrough,
                    //   ),
                    // ),
                    // Text(
                    //   "  ₹$salePrice",
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: 32,
                        ),
                        onPressed: () {
                          if (purchaseable) {
                            customLoader(context);
                            wooCommerce
                                .addToMyCart(
                              itemId: productId,
                              quantity: "1",
                            )
                                .then((res) {
                              print(res);
                              Navigator.of(context).pop();
                              Provider.of<AppState>(context, listen: false)
                                  .incrementCartItemCount();
                            }).catchError((e) {
                              Navigator.of(context).pop();
                              print(e);
                            });
                            // customLoader(context, txt: "Adding...");
                            // WooCommerce woo = WooCommerce(
                            //   baseUrl: rootlink,
                            //   consumerKey: consumer_key,
                            //   consumerSecret: consumer_secret,
                            // );
                            // woo
                            //     .addToMyCart(itemId: productId, quantity: "1")
                            //     .then((res) {})
                            //     .catchError((e) {
                            //   customAlert(
                            //       context, "Session out\nkindly login again");
                            //   Navigator.of(context).pushReplacement(
                            //       MaterialPageRoute(builder: (context) {
                            //     return LoginScreen();
                            //   }));
                            // });
                          } else {
                            customAlert(
                              context,
                              "This service is not purchasable",
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
