import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/widget/alert.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:minhajpublication/widget/roundedSqProductCard.dart';
import 'package:woocommerce/models/products.dart';

class ProductScreen extends StatefulWidget {
  final String productid;
  ProductScreen(this.productid);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  WooProduct _product;
  List<WooProduct> _relatedProducts;

  _getProduct() {
    wooCommerce.getProductById(id: int.parse(widget.productid)).then(
      (res) {
        setState(() {
          _product = res;
        });
        wooCommerce
            .getProducts(
          perPage: 10,
          category: _product.categories.first.id.toString(),
        )
            .then(
          (res) {
            setState(() {
              _relatedProducts = res;
            });
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Minhaj Publications'),
      ),
      drawer: CustomDrawer(),
      body: _product == null
          ? Container(
              height: size.height,
              width: size.width,
              color: color_primary.withOpacity(0.1),
              child: SpinKitRipple(
                color: color_primary,
              ),
            )
          : SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Container(
                color: color_primary.withOpacity(0.1),
                // height: size.heigh0t,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      items: _product.images.map((e) {
                        return Container(
                          width: size.width,
                          height: 210,
                          child: Image.network(
                            e.src,
                            fit: BoxFit.fill,
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        height: 210,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Text(
                        _product.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹" + _product.price,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              customAlert(context, "Adding");
                              wooCommerce
                                  .addToMyCart(
                                itemId: _product.id.toString(),
                                quantity: "1",
                              )
                                  .then(
                                (res) {
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Short Description",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Html(data: _product.shortDescription),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Html(data: _product.description),
                        ],
                      ),
                    ),
                    _relatedProducts == null
                        ? SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Related Products",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  child: Wrap(
                                    spacing: 8,
                                    children: _relatedProducts.map(
                                      (e) {
                                        return roundedSqProductCard(
                                          context,
                                          size,
                                          name: e.name,
                                          price: e.price,
                                          productID: e.id,
                                          images: e.images,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
