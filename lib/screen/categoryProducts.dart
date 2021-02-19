import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/product.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/woocommerce.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryId;
  CategoryProductScreen(this.categoryId);
  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  List<WooProduct> _products;
  TextEditingController _search = TextEditingController();
  ScrollController _listScrollContoller = ScrollController();
  bool _isLazyLoading = false;
  int _pageNumToLoad = 1;

  _getProducts(String search) async {
    List<WooProduct> products = await wooCommerce.getProducts(
        page: _pageNumToLoad, perPage: 6, category: widget.categoryId);
    setState(() {
      _products = products;
    });
  }

  _getLazyProducts(String search) async {
    List<WooProduct> lazyProducts = await wooCommerce.getProducts(
        page: (_pageNumToLoad + 1), perPage: 6, category: widget.categoryId);
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
    _getProducts(_search.text);
    _lazyLoading();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhaj Publications'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: _products == null
          ? Container(
              height: size.height,
              width: size.width,
              color: color_primary.withOpacity(0.1),
              child: SpinKitRipple(color: color_primary),
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
                            size: 28,
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProductScreen(
                                      _products[index].id.toString());
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
                            regularPrice: _products[index].regularPrice,
                            // sku: _products[index].sku,
                            rating: _products[index].ratingCount.toString(),
                            salePrice: _products[index].salePrice,
                            productId: _products[index].id.toString(),
                            purchaseable: _products[index].purchasable,
                            context: context,
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
  String productShortDescription,
  String regularPrice,
  String salePrice,
  String productId,
  bool purchaseable,
  String rating,
  BuildContext context,
}) {
  return Container(
    width: size.width,
    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1.6),
    padding: EdgeInsets.all(3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width - 140 - 24,
                child: Text(
                  productName.replaceAll("&amp;", "&"),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                    color: color_primary,
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_half,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      "$rating",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: size.width - 140 - 24,
                margin: EdgeInsets.symmetric(vertical: 2),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "₹$regularPrice",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: salePrice == null || salePrice == ""
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                      ),
                    ),
                    salePrice == null || salePrice == ""
                        ? SizedBox.shrink()
                        : Text(
                            "  ₹$salePrice",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        size: 32,
                      ),
                      onPressed: () {
                        customLoader(context, txt: "Adding");
                        wooCommerce
                            .addToMyCart(
                                itemId: productId.toString(), quantity: "1")
                            .then((value) {
                          Provider.of<AppState>(context, listen: false)
                              .incrementCartItemCount();
                          Navigator.of(context).pop();
                        });
                      },
                    ),
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
