import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constaints.dart';

class AppInfoBox extends StatefulWidget {
  const AppInfoBox({Key? key}) : super(key: key);

  @override
  State<AppInfoBox> createState() => _AppInfoBoxState();
}

class _AppInfoBoxState extends State<AppInfoBox> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: settingBoxColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text('앱 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          ListTile(
            title: Text('앱 버전'),
            trailing: Text(_packageInfo.version),
          )
        ],
      ),
    );
  }
}
