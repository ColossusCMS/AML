import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../access_info/app_access_info.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
enum DeviceMode {cover, main, tablet}

class MainStore extends ChangeNotifier {
  var deviceWidth;
  var deviceHeight;
  var loginStatus = false;
  var rememberLogin = false;
  var pageIndex;
  var userMail;
  var userProfileImg;
  var userNickname;
  bool isIndicatorVisible = false;

  changeIndicatrorState(bool state) {
    isIndicatorVisible = state;
    notifyListeners();
  }

  getDeviceWidth(width) {
    deviceWidth = width;
  }

  getDeviceHeight(height) {
    deviceHeight = height;
  }

  getInitUserInfo(email) async {
    getUserNickname(email);
  }

  signup(id, pwd, name, img) async {
    try {
      await auth.createUserWithEmailAndPassword(email: id, password: pwd).then((value) {
        print('FirebaseAuth 등록 성공');
      }).catchError((e) {
        print('FirebaseAuth 등록 실패');
      });
      await firestore.collection('user').add({'email' : id, 'nickname' : name, 'img' : img}).then((value) {
        print('FireStore 저장 성공');
      }).catchError((e) {
        print('FireStore 저장 실패');
      });
      print('사용자 등록 성공');
      return Future<bool>.value(true);
    } catch(e) {
      print('사용자 등록 실패');
      print(e);
      return Future<bool>.value(false);
    }
  }

  checkEmail(email) async{
    var result;
    await firestore.collection('user').where('email', isEqualTo: email).get().then((value) {
      if(value.size != 0) {
        result = Future<bool>.value(false);
      } else {
        result = Future<bool>.value(true);
      }
    });
    return result;
  }

  checkNickname(nickname) async {
    var result;
    await firestore.collection('user').where('nickname', isEqualTo: nickname).get().then((value) {
      if(value.size != 0) {
        print('중복된 별명');
        result = Future<bool>.value(true);
      } else {
        print('중복된 별명 없음');
        result = Future<bool>.value(false);
      }
    });
    return result;
  }

  signin(id, pwd) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: id,
          password: pwd
      );
      print('로그인 처리 완료');
      changeLoginStatus(true);
      getProfileImg(id);
      getInitUserInfo(id);
      notifyListeners();
      return Future<bool>.value(true);
    } catch(e) {
      print('로그인 처리 실패 id : $id');
      print(e);
      return Future<bool>.value(false);
    }
  }

  logout() async {
    try {
      print('로그아웃 처리 완료 id : ${auth.currentUser?.email}');
      changeLoginStatus(false);
      notifyListeners();
      return await auth.signOut();
    } catch(e) {
      print('로그아웃 처리 실패');
      print(e);
      return null;
    }
  }

  deleteUser() async {
    var docsId;
    await firestore.collection('user').where('email', isEqualTo: auth.currentUser?.email).get().then((value) {
      if(value.size != 0) {
        docsId = value.docs.first.id;
      }
    });
    try {
      print('사용자 삭제 완료 id : ${auth.currentUser?.email}');
      changeLoginStatus(false);
      notifyListeners();
      await auth.currentUser?.delete();
      await firestore.collection('user').doc(docsId).delete().then((value) {
        print('firestore에서 사용자 정보 삭제 완료');
      }).catchError((error) {
        print('firestore에서 사용자 정보 삭제 완료');
        print(error.toString());
      });
      return Future<bool>.value(true);
    } catch(e) {
      print('사용자 삭제 실패 id : ${auth.currentUser?.email}');
      print(e);
      return Future<bool>.value(false);
    }
  }

  getProfileImg(String email) async {
    var docsId;
    if(auth.currentUser != null) {
      await firestore.collection('user').where('email', isEqualTo: email).get().then((value) {
        if(value.size != 0) {
          docsId = value.docs.first.id;
        }
      });
    }

    if(docsId == null) {
      return;
    }

    await firestore.collection('user').doc(docsId).get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          userProfileImg = data['img'];
          notifyListeners();
        }
    );
    print(userProfileImg);
  }

  getUserNickname(String email) async {
    var docsId;
    if(auth.currentUser != null) {
      await firestore.collection('user').where('email', isEqualTo: email).get().then((value) {
        if(value.size != 0) {
          docsId = value.docs.first.id;
        }
      });
    }

    if(docsId == null) {
      return;
    }

    await firestore.collection('user').doc(docsId).get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          userNickname = data['nickname'];
          notifyListeners();
        }
    );
    // print(userNickname);
  }

  updateDocsData(email, key, data) async {
    var docsId;
    await firestore.collection('user').where('email', isEqualTo: email).get().then((value) {
      if(value.size != 0) {
        docsId = value.docs.first.id;
      }
    });

    if(docsId == null) {
      return;
    }

    await firestore.collection('user').doc(docsId).update({key:data}).then((value) {
      print('데이터 업데이트 성공');
    }).catchError((error) {
      print('데이터 업데이트에 실패했습니다. key: $key, data: $data');
      print(error.toString());
    });

    switch(key) {
      case 'img':
        getProfileImg(email);
        break;
      case 'nickname':
        getUserNickname(email);
        break;
    }
  }

  imgValidateCheck(String fileName) {
    // print(fileName);
    if(!RegExp(r'^([^\*\s]+(?=\.(jpg|jpeg|gif|png|bmp))\.)').hasMatch(fileName)) {
      return false;
    }
    return true;
  }

  profileImgUpload(selectedImage) async {
    var dio = Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      var formData = FormData.fromMap({
        'uploadFile': await MultipartFile.fromFile(selectedImage.path)
      });
      final response = await dio.post('$serverUrl/profileImgUpload.do', data: formData);
      print('response : ${response.data}');
      if(response.data) {
        print('프로필 이미지 서버 업로드 완료');
        return Future<bool>.value(true);
      } else {
        print('프로필 이미지 업로드 중에 오류가 발생했습니다.');
        return Future<bool>.value(false);
      }
    } catch(e) {
      print('이미지를 선택하지 않았거나 앱에서 문제가 발생했습니다.');
      print(e);
      return Future<bool>.value(false);
    }
  }

  changeLoginStatus(bool value) {
    userMail = value ? auth.currentUser?.email : null;
    loginStatus = value;
  }

  changeRememberLoginStatus() {
    rememberLogin = !rememberLogin;
    notifyListeners();
  }

  changePassword(newPassword) async {
    try {
      await auth.currentUser?.updatePassword(newPassword);
      return Future<bool>.value(true);
    } catch(e) {
      print(e);
      return Future<bool>.value(false);
    }

  }
}