import 'package:flutter/material.dart';
import 'package:aml/components/login_dialog.dart';
import 'package:aml/components/login_dialog_narrow.dart';
import 'package:aml/pages/user_info_page.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';
import '../constaints.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

class UserInfoBox extends StatefulWidget {
  const UserInfoBox({Key? key}) : super(key: key);

  @override
  State<UserInfoBox> createState() => _UserInfoBoxState();
}

class _UserInfoBoxState extends State<UserInfoBox> {
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
            child: Text('사용자 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          ListTile(
            title: Text(context.watch<MainStore>().userMail??'게스트 유저'),
            trailing: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFB2EBF2))
              ),
              child: (context.watch<MainStore>().loginStatus) ? Text('사용자 정보') : Text('로그인'),
              onPressed: () {
                if(context.read<MainStore>().loginStatus) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserInfoPage()));
                } else {
                  showDialog(context: context, builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: (context.watch<MainStore>().deviceWidth > 400) ? LoginDialog() : LoginDialogNarrow(),
                    );
                  });
                }
              },
            ),
          ),
          SwitchListTile(
              title: Text('자동 로그인'),
              value: context.read<MainStore>().rememberLogin,
              onChanged: (value) {
                context.read<MainStore>().changeRememberLoginStatus();
              }
          )
        ],
      ),
    );
  }
}
