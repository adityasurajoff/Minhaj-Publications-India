import 'dart:convert';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minhajpublication/constant/color.dart';
import 'package:minhajpublication/constant/link.dart';
import 'package:minhajpublication/screen/download/downloadCategoryItems.dart';
import 'package:minhajpublication/screen/download/downloadsearch.dart';
import 'package:minhajpublication/widget/customNetImageLoading.dart';
import 'package:minhajpublication/widget/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List _downloadCategories;
  List _homeDownloadables;

  _getDownloadCategories() async {
    String token;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      http.Response response = await http.post(
        "$rootlink/wp-json/jwt-auth/v1/token",
        body: {"username": "test@gmail.com", 'password': '12345678'},
      );
      Map json = jsonDecode(response.body);
      token = json['token'];
      sharedPreferences.setString("token", json['token']);
    } else {
      token = sharedPreferences.getString('token');
    }
    http.Response res = await http.get(
      '$rootlink/wp-json/wpdm/v1/categories?orderby=name&number=10',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    http.Response downloadres = await http.get(
      '$rootlink/wp-json/wpdm/v1/packages?number_of_posts=32',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );
    setState(() {
      print(res.body);
      _downloadCategories = jsonDecode(res.body);
      _homeDownloadables = jsonDecode(downloadres.body);
    });
  }

  @override
  void initState() {
    super.initState();
    _getDownloadCategories();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Downloads"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DownloadSearchScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _downloadCategories == null
          ? SpinKitRipple(
              color: color_primary,
            )
          : Container(
              height: size.height,
              width: size.width,
              color: color_primary.withOpacity(0.1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _downloadCategories.map((category) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return DownloadCategoryScreen(
                                    category['term_id'],
                                  );
                                }),
                              );
                            },
                            child: Container(
                              width: size.width / 2 + 30,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'asset/logo.png',
                                    height: 52,
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category['name'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          category['count'].toString() +
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
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height - 163,
                    width: size.width,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _homeDownloadables.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                                child: _homeDownloadables[index]['thumbnail'] ==
                                        false
                                    ? Image.asset('asset/logo.png')
                                    : ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5),
                                        ),
                                        child: customNetworkImageLoading(
                                          _homeDownloadables[index]['thumbnail']
                                              .toString(),
                                        ),
                                      ),
                              ),
                              Text(
                                // _homeDownloadables[index].toString(),
                                _homeDownloadables[index]['title'].toString(),
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
                                          _homeDownloadables[index]
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
                                          _homeDownloadables[index]
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
                                            "${_homeDownloadables[index]['files'][0]}",
                                        url:
                                            "http://minhajpublicationsindia.com/download/${_homeDownloadables[index]['slug']}/?wpdmdl=${_homeDownloadables[index]['id']}",
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
                  )
                ],
              ),
            ),
    );
  }
}
