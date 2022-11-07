import 'dart:convert';
import 'package:flutter/material.dart';
import '../access_info/app_access_info.dart';

import '/model/music_model.dart';
import 'package:http/http.dart' as http;

class MusicStore extends ChangeNotifier {
  var listData = [];
  List<Music> musicData = [];

  find(String title) async {
    musicData.clear();
    final url = Uri.parse('$serverUrl/findMusic.do?title=$title');
    var result = await http.get(url);
    var jsonData = jsonDecode(utf8.decode(result.bodyBytes));
    listData = jsonData;
    musicData = generateItems(listData.isEmpty ? 0 : listData.length, listData);
    notifyListeners();
  }
}

List<Music> generateItems(int numberOfItems, List listData) {
  return List<Music>.generate(numberOfItems, (index) {
    return Music(
      // id: listData[index]['id'],
      title: listData[index]['title'].toString(),
      artist: listData[index]['artist'].toString(),
      album: listData[index]['album'].toString(),
      path: listData[index]['path'].toString(),
      ext: listData[index]['ext'].toString(),
      albumArt: listData[index]['albumArt'].toString(),
    );
  });
}