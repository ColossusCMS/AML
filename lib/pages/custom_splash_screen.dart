import 'package:flutter/material.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';

import '../access_info/app_access_info.dart';
import '../stores/splash_store.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({Key? key}) : super(key: key);

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  String splashScreenImageName = '';

  getSplashScreenImage(String screenType) async {
    var result = await context.read<SplashStore>().getSplashScreenImageName(screenType);
    if(result is String) {
      setState(() {
        splashScreenImageName = result.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    context.read<MainStore>().getDeviceWidth(size.width);
    context.read<MainStore>().getDeviceHeight(size.height);
    String screenType = (context.watch<MainStore>().deviceWidth > 400) ? 'wide' : 'normal';

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
            future: getSplashScreenImage(screenType),
            builder: (context, snapshot) {
              return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (splashScreenImageName == '')
                              ? AssetImage('assets/splash/default_splash_screen.png')
                              : AssetImage('$splashScreenDirUrl/$screenType/$splashScreenImageName')
                      )
                  )
              );
            },
          ),
        ),
      ),
    );
  }
}
