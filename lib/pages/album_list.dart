// ignore: file_names
import 'package:flutter/material.dart';
import 'package:aml/components/custom_date_picker.dart';
import 'package:aml/components/top_button.dart';
import 'package:aml/components/album_list_tile.dart';
import 'package:aml/components/hide_floating_button.dart';
import 'package:aml/pages/fast_search_result_page.dart';
import 'package:aml/stores/main_store.dart';
import '../components/login_dialog.dart';
import '../components/login_dialog_narrow.dart';
import '/stores/album_store.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatefulWidget {
  const AlbumList({Key? key}) : super(key: key);

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  final HideFloatingButton hiding = HideFloatingButton();

  @override
  void initState() {
    super.initState();
    context.read<AlbumStore>().initData();
  }

  void fastSearch(String dateTime) {
    if(context.read<MainStore>().loginStatus) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FastSearchResultPage(dateTime: dateTime,)));
    } else {
      showDialog(context: context, builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0.0),
          child: (context
              .watch<MainStore>()
              .deviceWidth > 400) ? LoginDialog() : LoginDialogNarrow(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController dateInput = TextEditingController();

    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            context.read<AlbumStore>().initData();
          },
          child: SingleChildScrollView(
            controller: hiding.controller,
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: [
                  AlbumListTile(),
                  ListTile(
                      title: DatePicker(dateInput: dateInput, enabled: true),
                      trailing: ElevatedButton(
                          onPressed: () => fastSearch(dateInput.text),
                          child: Text('빠른 검색')
                      )
                  )
                ],
              ),
              // child: AlbumListTile(),
            ),
          ),
        ),
        floatingActionButton: TopButton(hiding: hiding,)
    );
  }
}