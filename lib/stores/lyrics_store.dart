import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aml/model/lyrics_model.dart';
import 'package:http/http.dart' as http;

import '../access_info/app_access_info.dart';

class LyricsStore extends ChangeNotifier {
  var listData = [];
  List<Lyrics> lyricsData = [];

  searchMusic(String title, String site) async {
    listData.clear();
    lyricsData.clear();
    final url = Uri.parse('$lyricsControllerUrl/searchMusic.do?title=$title&site=$site');
    var result = await http.get(url);
    var jsonData = jsonDecode(utf8.decode(result.bodyBytes));
    listData = jsonData;
    lyricsData = generateItems(listData.isEmpty ? 0 : listData.length, listData);
    notifyListeners();
  }

  getLyrics(String titleId, String site) async {
    final url = Uri.parse('$lyricsControllerUrl/getLyrics.do?title_id=$titleId&site=$site');
    var result = await http.get(url);
    var jsonData = jsonDecode(utf8.decode(result.bodyBytes));
    return jsonData;
  }
}

List<Lyrics> generateItems(int numberOfItems, List listData) {
  return List<Lyrics>.generate(numberOfItems, (index) {
    return Lyrics(
      title: listData[index]['title'].toString(),
      titleId: listData[index]['title_id'].toString(),
      artist: listData[index]['artist'].toString(),
      site: listData[index]['site'].toString(),
      lyrics: '',
    );
  });
}