import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/main.dart';
import 'package:minhajpublication/model/state.dart';
import 'package:minhajpublication/screen/categories.dart';
import 'package:minhajpublication/screen/download/downlods.dart';
import 'package:minhajpublication/screen/editProfile.dart';
import 'package:minhajpublication/screen/myorders.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woocommerce/models/customer.dart';

class CustomDrawer extends Drawer {
  @override
  Widget build(BuildContext context) {
    WooCustomer customer = Provider.of<AppState>(context).customer;
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 120,
      height: size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: size.width - 120,
              color: color_primary,
              child: UserAccountsDrawerHeader(
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: customer == null
                      ? Image.asset('asset/logo.png')
                      : customNetworkImageLoading(customer.avatarUrl),
                ),
                otherAccountsPictures: [
                  CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EditMyProfilecreen();
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
                accountName: Text(customer.firstName + " " + customer.lastName),
                accountEmail: Text(customer.email),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                size: 26,
              ),
              title: Text(
                "Home",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return MinhajApp();
                //     },
                //   ),
                // );
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return MinhajApp();
                }), (route) => false);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.file_download,
                size: 26,
              ),
              title: Text(
                "Downloads",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DownloadScreen();
                    },
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.shopping_bag,
            //     size: 26,
            //   ),
            //   title: Text(
            //     "Shop",
            //     style: TextStyle(fontSize: 15),
            //   ),
            //   onTap: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) {
            //           return ShopScreen();
            //         },
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.store_mall_directory,
                size: 26,
              ),
              title: Text(
                "MyOrders",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return MyOrderScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.book,
                size: 26,
              ),
              title: Text(
                "Books",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoriesScreen(63);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.category,
                size: 26,
              ),
              title: Text(
                "Categories",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoriesScreen(75);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.library_books,
                size: 26,
              ),
              title: Text(
                "Syllabus",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CategoriesScreen(67);
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 26,
              ),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove('islogined');
                Provider.of<AppState>(context, listen: false)
                    .setIsLogined(false);
                wooCommerce.logUserOut();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "More",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                size: 26,
              ),
              title: Text(
                "Share",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Share.text(
                    "Share Minhaj Publications India App",
                    "https://play.google.com/store/apps/details?id=com.bridge2business.minhajpublication",
                    "text/plain");
              },
            ),
            ListTile(
              leading: Icon(
                Icons.web,
                size: 26,
              ),
              title: Text(
                "Our Website",
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                String link = "http://minhajpublicationsindia.com/";
                if (canLaunch(link) != null) {
                  launch(link);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
