import 'dart:async';

import 'package:aml/pages/main_branch_page.dart';
import 'package:flutter/material.dart';

import '/stores/main_store.dart';
import '/stores/lyrics_store.dart';
import '/stores/album_store.dart';
import '/stores/music_store.dart';
import '/stores/splash_store.dart';
import '/theme/style.dart' as style;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/custom_splash_screen.dart';
final auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    // 세로모드 고정
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]
    // 가로모드 고정
    // [
    // DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => MainStore()),
        ChangeNotifierProvider(create: (c) => AlbumStore()),
        ChangeNotifierProvider(create: (c) => MusicStore()),
        ChangeNotifierProvider(create: (c) => LyricsStore()),
        ChangeNotifierProvider(create: (c) => SplashStore()),
      ],
      child: MaterialApp(
        theme: style.CustomTheme.light(),
        darkTheme: style.CustomTheme.dark(),
        themeMode: ThemeMode.system,
        home: MyApp()
      ),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Timer(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainBranchPage()
        )
      );
    });
    final currentUser = auth.currentUser;
    if(currentUser != null) {
      print('이전에 로그인한 정보가 남아있음');
      context.read<MainStore>().getProfileImg(currentUser.email.toString());
      context.read<MainStore>().changeLoginStatus(true);
      context.read<MainStore>().getInitUserInfo(currentUser.email.toString());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('###### state : $state');
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("resumed");
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.paused:
        print("paused");
        break;
      case AppLifecycleState.detached:
        print("detached");
        // if(!context.read<MainStore>().rememberLogin && context.read<MainStore>().loginStatus) {
        //   print('로그인 상태에서 로그인 유지 체크 안한 상태');
        //   context.read<MainStore>().logout();
        // }
        break;
      default:
        print('@@@@@ finish');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen();
  }
}
