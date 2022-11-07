import 'package:flutter/material.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';
import '../components/custom_snackbar.dart';
import '../components/user_info_box.dart';
import '../components/app_info_box.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoBox(),
          // AppSettingBox(),
          AppInfoBox(),
          Visibility(
              visible: context.watch<MainStore>().loginStatus,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)
                    ),
                    onPressed: () {
                      context.read<MainStore>().logout();
                      CustomSnackbar.snackbar(context, '로그아웃 완료', 'normal');
                    },
                    child: Text('로그아웃')
                ),
              )
          ),
          Center(child: Text('2020-2022 Munseok Choi'))
        ],
      ),
    );
  }
}