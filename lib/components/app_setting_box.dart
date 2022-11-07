import 'package:flutter/material.dart';
import '../constaints.dart';

class AppSettingBox extends StatefulWidget {
  const AppSettingBox({Key? key}) : super(key: key);

  @override
  State<AppSettingBox> createState() => _AppSettingBoxState();
}

class _AppSettingBoxState extends State<AppSettingBox> {
  List<String> themes = ['시스템 기본값', '밝은 테마', '어두운 테마'];
  String _selectedTheme = '시스템 기본값';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: settingBoxColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text('앱 설정', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          ListTile(
            title: Text('테마'),
            trailing: PopupMenuButton(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(_selectedTheme),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: themes[0],
                  child: Text(themes[0]),
                ),
                PopupMenuItem(
                  value: themes[1],
                  child: Text(themes[1]),
                ),
                PopupMenuItem(
                  value: themes[2],
                  child: Text(themes[2]),
                )
              ],
              onSelected: (value) {
                setState(() {
                  _selectedTheme = value.toString();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
