import 'package:flutter/material.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/product.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:minhajpublication/widget/loading.dart';
import 'package:provider/provider.dart';

Widget roundedSqProductCard(
  BuildContext context,
  Size size, {
  int productID,
  String name,
  String price,
  List images,
}) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ProductScreen(productID.toString());
          },
        ),
      );
    },
    child: Container(
      width: size.width / 2 - 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width / 2 - 12,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: customNetworkImageLoading(images.first.src),

              //  Image.network(
              //   images.first.src,
              //   height: 140,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹" + price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    customLoader(context, txt: "Adding");
                    wooCommerce
                        .addToMyCart(
                            itemId: productID.toString(), quantity: "1")
                        .then((value) {
                      Provider.of<AppState>(context, listen: false)
                          .incrementCartItemCount();
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
