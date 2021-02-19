import 'package:flutter/material.dart';

Widget customNetworkImageLoading(String img) {
  return img == null
      ? Image.asset("asset/logo.jpg", fit: BoxFit.contain)
      : Image.network(
          img,
          fit: BoxFit.cover,
          height: 140,
          loadingBuilder: (context, child, loading) {
            if (loading == null) return child;
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset("asset/logo.png", fit: BoxFit.contain),
                Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loading.expectedTotalBytes != null
                          ? loading.cumulativeBytesLoaded /
                              loading.expectedTotalBytes
                          : null,
                    ),
                  ),
                ),
              ],
            );
          },
        );
}
