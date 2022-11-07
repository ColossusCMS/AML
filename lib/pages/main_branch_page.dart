import 'package:flutter/material.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:aml/components/login_dialog.dart';
import 'package:aml/pages/album_entry.dart';
import 'package:aml/pages/album_list.dart';
import 'package:aml/pages/search_lyrics.dart';
import 'package:aml/pages/search_music.dart';
import 'package:aml/pages/setting_page.dart';
import 'package:provider/provider.dart';

import '../access_info/app_access_info.dart';
import '../components/login_dialog_narrow.dart';
import '../stores/main_store.dart';

class MainBranchPage extends StatefulWidget {
  const MainBranchPage({Key? key, this.pageIndex = 0}) : super(key: key);
  final pageIndex;

  @override
  State<MainBranchPage> createState() => _MainBranchPageState();
}

class _MainBranchPageState extends State<MainBranchPage> {
  DateTime? currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _selectedPageName = ['앨범 목록', '앨범 등록', '음악 검색', '가사 검색', '설정'];
  int _selectedIndex = 0;
  var _controller;

  @override
  initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
    _controller = PageController(initialPage: _selectedIndex);
  }

  onItemTapped(index) {
    if(index == 1) {
      if(!context.read<MainStore>().loginStatus) {
        CustomSnackbar.snackbar(context, '로그인이 필요합니다.', 'warning');
        return;
      }
    }
    _controller.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if(currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        CustomSnackbar.snackbar(context, '뒤로 버튼을 한 번 더 누르시면 종료됩니다.', 'normal');
        return Future.value(false);
      }
      return Future.value(true);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: context.watch<MainStore>().loginStatus ? Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(context.watch<MainStore>().userProfileImg??'$profileImgUrl/login.png'),
                fit: BoxFit.fitWidth,
              )
          ),
          margin: EdgeInsets.all(5.0),
        ) : SizedBox(),
        toolbarHeight: 50.0,
        title: Text(_selectedPageName[_selectedIndex]),
        actions: [
          (_selectedIndex == 0 || _selectedIndex == 2 || _selectedIndex == 3) ? IconButton(
              onPressed: () {
                if(context.read<MainStore>().loginStatus) {
                  context.read<MainStore>().logout();
                  CustomSnackbar.snackbar(context, '로그아웃 완료', 'normal');
                } else {
                  showDialog(context: context, builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: (context.watch<MainStore>().deviceWidth > 400) ? LoginDialog() : LoginDialogNarrow(),
                    );
                  });
                }
              },
              icon: context.watch<MainStore>().loginStatus ? Icon(Icons.logout) : Icon(Icons.login)
          ) : SizedBox()
        ],
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            AlbumList(),
            AlbumEntry(pageController: onItemTapped,),
            SearchMusic(),
            SearchLyrics(),
            SettingPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.album),
              label: '앨범 목록',
              backgroundColor: Color(0xFFB3E5FC)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add),
              label: '앨범 등록',
              backgroundColor: Color(0xFFFFECB3)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: '음악 검색',
              backgroundColor: Color(0xFFE1BEE7)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.lyrics),
              label: '가사 검색',
              backgroundColor: Color(0xFFB2DFDB)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '설정',
              backgroundColor: Color(0xFFF8BBD0)
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: onItemTapped,
      ),
    );
  }
}
