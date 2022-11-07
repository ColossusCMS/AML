import 'package:flutter/material.dart';
import 'package:aml/components/top_button.dart';
import 'package:aml/components/hide_floating_button.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';
import '../stores/lyrics_store.dart';
import '../components/loading_container.dart';
import 'info_box.dart';

class SearchLyrics extends StatefulWidget {
  const SearchLyrics({Key? key}) : super(key: key);

  @override
  State<SearchLyrics> createState() => _SearchLyricsState();
}

class _SearchLyricsState extends State<SearchLyrics> {
  final HideFloatingButton hiding = HideFloatingButton();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Finder(width: width),
          context.watch<LyricsStore>().lyricsData.isEmpty ? LoadingContainer() : LyricsListTile(scrollController: hiding.controller,),
        ],
      ),
      floatingActionButton: TopButton(hiding: hiding),
    );
  }
}

class Finder extends StatefulWidget {
  const Finder({Key? key, this.width}) : super(key: key);
  final width;

  @override
  State<Finder> createState() => _FinderState();
}

class _FinderState extends State<Finder> {
  TextEditingController finderController = TextEditingController();
  final _sites = ['Vibe', 'J-Lyrics'];
  var _selectedSite = 'Vibe';

  submit() async {
    if(finderController.text.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      context.read<MainStore>().changeIndicatrorState(true);
      await context.read<LyricsStore>().searchMusic(finderController.text, _selectedSite);
      context.read<MainStore>().changeIndicatrorState(false);
    } else {
      showDialog(context: context, builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          content: SizedBox(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('검색어를 1자 이상 입력하세요.', style: TextStyle(fontSize: 13),),
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: widget.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xFFE8E8E8)
      ),
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: TextField(
        textInputAction: TextInputAction.go,
        onSubmitted: (value) async {
          submit();
        },
        controller: finderController,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: DropdownButton(
              value: _selectedSite,
              items: _sites.map((value) {
                return DropdownMenuItem(
                    value: value,
                    child: Text(value)
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSite = value.toString();
                });
              },
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                submit();
              },
            ),
            hintText: '제목',
            hintStyle: TextStyle(
              color: Colors.grey,
            )
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),
      ),
    );
  }
}

class LyricsListTile extends StatefulWidget {
  const LyricsListTile({Key? key, this.scrollController}) : super(key: key);
  final scrollController;

  @override
  State<LyricsListTile> createState() => _LyricsListTileState();
}

class _LyricsListTileState extends State<LyricsListTile> {
  @override
  Widget build(BuildContext context) {
    var data = context.watch<LyricsStore>().lyricsData;

    return Expanded(
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xFFF3F1F7),
            ),
            margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ListTile(
              title: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    text: data[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
              ),
              subtitle: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    text: data[index].artist,
                    style: Theme.of(context).textTheme.labelMedium,
                  )
              ),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.grey),
                onPressed: () async {
                  if(data[index].lyrics.isEmpty) {
                    var result = await context.read<LyricsStore>().getLyrics(data[index].titleId, data[index].site);
                    data[index].lyrics = result.toString();
                  }
                  print('[DEBUG] lyrics length : ${data[index].lyrics.length}');
                  Map<String, String> mapData = {
                    'title' : data[index].title,
                    'artist' : data[index].artist,
                    'lyrics' : data[index].lyrics,
                  };
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoBox(data : mapData, type: 'L',))
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
