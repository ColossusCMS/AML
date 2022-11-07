import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:aml/model/album_model.dart';
import 'package:aml/model/simple_album_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../access_info/app_access_info.dart';
final auth = FirebaseAuth.instance;

class AlbumStore extends ChangeNotifier {
  List<Album> albumData = [];
  List<SimpleAlbumModel> simpleAblumData = [];
  var listData = [];
  var date;

  albumArtUpload(selectedImage) async {
    var dio = Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      var formData = FormData.fromMap({
        'uploadFile': await MultipartFile.fromFile(selectedImage.path)
      });
      final response = await dio.post('$serverUrl/albumArtUpload.do', data: formData);
      print('response : ${response.data}');
      if(response.data) {
        print('앨범아트 서버 업로드 완료');
        return Future<bool>.value(true);
      } else {
        print('앨범아트 업로드 중에 오류가 발생했습니다.');
        return Future<bool>.value(false);
      }
    } catch(e) {
      print('이미지를 선택하지 않았거나 앱에서 문제가 발생했습니다.');
      print(e);
      return Future<bool>.value(false);
    }
  }

  initData() async {
    var result = await http.get(Uri.parse('$serverUrl/list_asc'));
    var jsonData = jsonDecode(utf8.decode(result.bodyBytes));
    listData = jsonData;
    albumData = generateItems(listData.isEmpty ? 0 : listData.length, listData);
    notifyListeners();
  }

  postAlbum(bodyData, command) async {
    String commandUrl = '';
    switch(command) {
      case 'update':
        commandUrl = 'update.do';
        break;
      case 'delete':
        commandUrl = 'delete.do';
        break;
    }
    final url = Uri.parse('$serverUrl/$commandUrl');
    final response = await http.post(url, body: bodyData);
    print('Response Status : ${response.statusCode}');

    initData();
  }

  submit(Map<String, String> bodyData) async {
    final url = Uri.parse('$serverUrl/register.do');
    final response = await http.post(url, body: bodyData);
    final status = response.statusCode;
    if(status == 200 || status == 201) {
      print('Status[$status] : 데이터 전송 성공');
      return Future.value(true);
    } else {
      print('Status[$status] : 서버와의 연결이 불안정합니다.');
      return Future.value(false);
    }
  }

  convertDateTime(String dateTime) {
    String date;
    DateTime now = DateTime.now();
    String defaultDate = DateFormat('yyMMdd').format(now);
    if(dateTime == '' || dateTime.isEmpty) {
      date = defaultDate;
    } else {
      date = dateTime.substring(2).replaceAll("-", "");
    }
    return date;
  }

  fastSearchAlbum(String dateTime) async {
    listData.clear();
    simpleAblumData.clear();
    // print(dateTime);
    String date = convertDateTime(dateTime);
    final url = Uri.parse('$fastSearchUrl/searchAlbum.do?dateTime=$date');
    var result = await http.get(url);
    if(result.body != 'No Data') {
      var jsonData = jsonDecode(utf8.decode(result.bodyBytes));
      listData = jsonData;
    }
    simpleAblumData = generateFastSearchItems(listData.isEmpty ? 0 : listData.length, listData);
    notifyListeners();
  }
}

List<Album> generateItems(int numberOfItems, List listData) {
  return List<Album>.generate(numberOfItems, (index) {
    return Album(
      id: listData[index]['id'],
      released: listData[index]['released'].toString(),
      title: listData[index]['title'].toString(),
      artist: listData[index]['artist'].toString(),
      artistGroup: listData[index]['artistGroup'].toString(),
      albumArt: listData[index]['albumArt'].toString(),
    );
  });
}

List<SimpleAlbumModel> generateFastSearchItems(int numberOfItems, List listData) {
  return List<SimpleAlbumModel>.generate(numberOfItems, (index) {
    return SimpleAlbumModel(
      category: listData[index]['category'].toString(),
      title: listData[index]['title'].toString(),
    );
  });
}