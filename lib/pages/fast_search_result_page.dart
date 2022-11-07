import 'package:flutter/material.dart';
import 'package:aml/components/hide_floating_button.dart';
import 'package:aml/components/loading_container.dart';
import 'package:aml/components/simple_album_list_tile.dart';
import 'package:aml/components/top_button.dart';
import 'package:provider/provider.dart';

import '../stores/album_store.dart';

class FastSearchResultPage extends StatefulWidget {
  const FastSearchResultPage({Key? key, required this.dateTime}) : super(key: key);
  final String dateTime;

  @override
  State<FastSearchResultPage> createState() => _FastSearchResultPageState();
}

class _FastSearchResultPageState extends State<FastSearchResultPage> {
  final HideFloatingButton hiding = HideFloatingButton();

  @override
  initState() {
    context.read<AlbumStore>().fastSearchAlbum(widget.dateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_outlined),
        ),
        title: Text('빠른 앨범 검색'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          context.read<AlbumStore>().fastSearchAlbum(widget.dateTime);
        },
        child: context.watch<AlbumStore>().simpleAblumData.isEmpty ? LoadingContainer() : SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: hiding.controller,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: SimpleAlbumListTile(dateTime: widget.dateTime, index: 1,),
          ),
        ),
      ),
      floatingActionButton: TopButton(hiding: hiding),
    );
  }
}
