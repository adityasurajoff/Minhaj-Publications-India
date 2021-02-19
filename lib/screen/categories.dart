import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/screen/categoryProducts.dart';
import 'package:woocommerce/models/product_category.dart';

class CategoriesScreen extends StatefulWidget {
  final int categoryID;
  CategoriesScreen(this.categoryID);
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<WooProductCategory> _categories;

  _getCategories() {
    wooCommerce.getProductCategories(parent: widget.categoryID).then((res) {
      setState(() {
        _categories = res;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Minhaj Publications'),
      ),
      body: _categories == null
          ? SpinKitRipple(
              color: color_primary,
            )
          : Container(
              width: size.width,
              height: size.height,
              color: color_primary.withOpacity(0.1),
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return CategoryProductScreen(
                              _categories[index].id.toString(),
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          (_categories[index].image == null ||
                                  _categories[index].image == "")
                              ? Image.asset(
                                  'asset/logo.png',
                                  height: 52,
                                )
                              : Image.network(_categories[index].image.src),
                          SizedBox(width: 8),
                          Container(
                            width: size.width - 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _categories[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Collection of " +
                                      _categories[index].count.toString() +
                                      " books",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
