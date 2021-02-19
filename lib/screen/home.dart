import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/mycart.dart';
import 'package:minhajpublication/screen/search.dart';
import 'package:minhajpublication/widget/circlurCategroy.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:minhajpublication/widget/roundedSqProductCard.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce/models/product_category.dart';
import 'package:woocommerce/models/products.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WooProduct> _featuredReleasesProducts;
  List<WooProductCategory> _booksCategories;
  List<WooProduct> _booksProducts;
  _getFeaturedReleases() {
    wooCommerce.getProducts(featured: true, perPage: 6).then((res) {
      setState(() {
        _featuredReleasesProducts = res;
      });
    });
    wooCommerce.getProducts(perPage: 6, category: 67.toString()).then((res) {
      setState(() {
        _booksProducts = res;
      });
    });
    wooCommerce.getProductCategories(parent: 63).then((res) {
      setState(() {
        _booksCategories = res;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getFeaturedReleases();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text(
          "Minhaj Publications",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          Stack(
            children: [
              Provider.of<AppState>(context, listen: false).cartItemCount == 0
                  ? SizedBox.shrink()
                  : Positioned(
                      right: 4,
                      top: 3,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Center(
                          child: Text(
                            Provider.of<AppState>(context, listen: false)
                                .cartItemCount
                                .toString(),
                            style: TextStyle(
                              color: color_primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MyCartScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SearchScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: _featuredReleasesProducts == null || _booksCategories == null
          ? Container(
              height: size.height,
              width: size.width,
              color: color_primary.withOpacity(0.1),
              child: SpinKitRipple(
                color: color_primary,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                color: color_primary.withOpacity(0.1),
                child: Column(
                  children: [
                    CarouselSlider(
                      items: [
                        Image.asset('asset/46.jpg'),
                        Image.asset('asset/47.jpg'),
                        Image.asset('asset/48.jpg')
                      ],
                      options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        height: 180,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            "Books",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: _booksCategories.map((e) {
                              return circularCategory(
                                context,
                                id: e.id.toString(),
                                name: e.name,
                                image: e.image == null ? null : e.image.src,
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            "Featured Releases",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "Collection of our featured books ",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _featuredReleasesProducts.map(
                        (e) {
                          return roundedSqProductCard(
                            context,
                            size,
                            productID: e.id,
                            name: e.name,
                            price: e.price,
                            images: e.images,
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            "Syllables",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _booksProducts.map(
                        (e) {
                          return roundedSqProductCard(
                            context,
                            size,
                            productID: e.id,
                            name: e.name,
                            price: e.price,
                            images: e.images,
                          );
                        },
                      ).toList(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
