import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../access_info/app_access_info.dart';

class SplashStore extends ChangeNotifier {
  getSplashScreenImageName(String screenType) async {
    final url = Uri.parse('$serverUrl/getRandomSplashScreen.do?screenType=$screenType');
    var result = await http.get(url);
    if(result.body == '909') {
      print('[DEBUG] : 선택된 이미지가 없습니다.');
      return '';
    } else {
      return result.body;
    }
  }
}