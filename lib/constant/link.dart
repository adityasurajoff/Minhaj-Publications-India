import 'package:woocommerce/woocommerce.dart';

String rootlink = "https://minhajpublicationsindia.com";
String consumer_key = "ck_6a7c4bb44551a4d3c44a7557ab6cef429144d2ac";
String consumner_secret = "cs_8b6e6d4d22e0c95d8e6e928defd268748a16c458";

WooCommerce wooCommerce = WooCommerce(
  baseUrl: rootlink,
  consumerKey: consumer_key,
  consumerSecret: consumner_secret,
);
