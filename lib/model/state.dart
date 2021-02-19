import 'package:flutter/foundation.dart';
import 'package:woocommerce/models/cart_item.dart';
import 'package:woocommerce/models/customer.dart';

class AppState extends ChangeNotifier {
  int cartItemCount = 0;
  WooCustomer customer;
  bool islogined = false;
  List<WooCartItem> cartItems;

  void incrementCartItemCount() {
    cartItemCount += 1;
    notifyListeners();
  }

  void decrementCartItemCount() {
    cartItemCount -= 1;
    notifyListeners();
  }

  void setCartItemCount(int val) {
    cartItemCount = val;
    notifyListeners();
  }

  void setCustomer(WooCustomer custom) {
    customer = custom;
    notifyListeners();
  }

  void setIsLogined(bool stat) {
    islogined = stat;
    notifyListeners();
  }

  void setCartItems(List<WooCartItem> items) {
    cartItems = items;
    notifyListeners();
  }
}
