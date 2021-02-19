import 'dart:convert';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DownloadSearchScreen extends StatefulWidget {
  @override
  _DownloadSearchScreenState createState() => _DownloadSearchScreenState();
}

class _DownloadSearchScreenState extends State<DownloadSearchScreen> {
  List _searchDownloads;
  TextEditingController _searched = TextEditingController();
  bool _isSearching = false;

  _getSearchDownload() async {
    setState(() {
      _isSearching = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    http.get(
      '$rootlink/wp-json/wpdm/v1/packages?number_of_posts=32&search=${_searched.text}',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    ).then((res) {
      setState(() {
        _isSearching = false;
        _searchDownloads = jsonDecode(res.body);
      });
      print(_searchDownloads);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: TextField(
            controller: _searched,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: "Search for book"),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _getSearchDownload();
            },
          ),
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: color_primary.withOpacity(0.1),
        child: _searchDownloads == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/logo.png',
                    height: 160,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "Search for the books\nYou want to download",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: color_primary, fontSize: 16),
                  )
                ],
              )
            : _isSearching
                ? SpinKitRipple(
                    color: color_primary,
                  )
                : _searchDownloads.length == 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/logo.png',
                            height: 160,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Book you are looking for isn't available",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: color_primary, fontSize: 16),
                          )
                        ],
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _searchDownloads.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 180,
                                  width: size.width,
                                  color: color_primary.withOpacity(0.1),
                                  child: _searchDownloads[index]['thumbnail'] ==
                                          false
                                      ? Image.asset('asset/logo.png')
                                      : ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                          child: customNetworkImageLoading(
                                            _searchDownloads[index]['thumbnail']
                                                .toString(),
                                          ),
                                        ),
                                ),
                                Text(
                                  // _homeDownloadables[index].toString(),
                                  _searchDownloads[index]['title'].toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: color_primary,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        "Download Size: " +
                                            _searchDownloads[index]
                                                ['package_size'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: color_primary,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.file_download,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            _searchDownloads[index]
                                                    ['download_count']
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: RaisedButton(
                                    color: color_primary,
                                    child: Text(
                                      "Download",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      // print(_homeDownloadables[index]
                                      //         ['permalink'] +
                                      //     _homeDownloadables[index]['files'][0]);
                                      final path =
                                          await getExternalStorageDirectory();
                                      String pathSave = path.path +
                                          Platform.pathSeparator +
                                          'Download';
                                      final saveDir = Directory(pathSave);
                                      bool exists = await saveDir.exists();
                                      if (!exists) {
                                        saveDir.create();
                                      }
                                      var patht = await ExtStorage
                                          .getExternalStoragePublicDirectory(
                                              ExtStorage.DIRECTORY_DOWNLOADS);
                                      print(patht);
                                      var tocreate = Directory(patht +
                                          Platform.pathSeparator +
                                          "Minhaj Publications India");
                                      tocreate.create().then((res) async {
                                        print(res);
                                        FlutterDownloader.initialize();
                                        await FlutterDownloader.enqueue(
                                          fileName:
                                              "${_searchDownloads[index]['files'][0]}",
                                          url:
                                              "http://minhajpublicationsindia.com/download/${_searchDownloads[index]['slug']}/?wpdmdl=${_searchDownloads[index]['id']}",
                                          savedDir: res.path,
                                          showNotification: true,
                                          openFileFromNotification: true,
                                        );
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
