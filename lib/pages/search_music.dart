import 'package:flutter/material.dart';
import 'package:aml/components/top_button.dart';
import 'package:aml/components/hide_floating_button.dart';
import 'package:provider/provider.dart';
import '../stores/main_store.dart';
import '/stores/music_store.dart';
import '../components/loading_container.dart';
import '../pages/info_box.dart';

class SearchMusic extends StatefulWidget {
  const SearchMusic({Key? key}) : super(key: key);

  @override
  State<SearchMusic> createState() => _SearchMusicState();
}

class _SearchMusicState extends State<SearchMusic> {
  final HideFloatingButton hiding = HideFloatingButton();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Finder(width: width,),
          context.watch<MusicStore>().musicData.isEmpty ? LoadingContainer() : MusicListTile(width: width, scrollController: hiding.controller,),
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

  submit() async {
    if(finderController.text.trim().length > 2) {
      FocusScope.of(context).unfocus();
      context.read<MainStore>().changeIndicatrorState(true);
      await context.read<MusicStore>().find(finderController.text);
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
                Text('검색어를 3자 이상 입력하세요.', style: TextStyle(fontSize: 13),),
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
        onSubmitted: (value) {
          submit();
        },
        controller: finderController,
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
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

class MusicListTile extends StatefulWidget {
  const MusicListTile({Key? key, this.width, this.scrollController}) : super(key: key);
  final width;
  final scrollController;

  @override
  State<MusicListTile> createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
  @override
  Widget build(BuildContext context) {
    var width = widget.width;

    return Expanded(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
          child: ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                context.read<MusicStore>().musicData[index].isExpanded = !isExpanded;
              });
            },
            children: context.read<MusicStore>().musicData.map<ExpansionPanel>((item) {
              return ExpansionPanel(
                backgroundColor: Color(0xFFF3F1F7),
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: (isExpanded == false) ?
                    Row(
                      children: [
                        Flexible(
                          flex: 9,
                          fit: FlexFit.loose,
                          child: SizedBox(
                            child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: item.title,
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                            ),
                          ),
                        )
                      ],
                    ) : SizedBox(
                      child: RichText(
                        text: TextSpan(
                          text: item.title,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  );
                },
                body: ListTile(
                  horizontalTitleGap: 0,
                  contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                  title: Row(
                    children: [
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   padding: EdgeInsets.zero,
                      //   child: Image.file(File(item.albumArt),
                      //     width: 100,
                      //     height: 100,
                      //     fit: BoxFit.cover,
                      //     errorBuilder: (context, error, stackTrace) {
                      //       return Image.network(defaultAlbumArtUrl, width: 100, height: 100, fit:BoxFit.cover,);
                      //     },
                      //   ),
                      // ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: (width > 400) ? '가수 : ' : 'S: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          )
                                      ),
                                      TextSpan(
                                          text: item.artist,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: (width > 400) ? '앨범 : ' : 'A: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          )
                                      ),
                                      TextSpan(
                                          text: item.album,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: (width > 400) ? '경로 : ' : 'P: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          )
                                      ),
                                      TextSpan(
                                          text: item.path,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                    ]
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: (width > 400) ? '확장자 : ' : 'E: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          )
                                      ),
                                      TextSpan(
                                          text: item.ext,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          )
                                      )
                                    ]
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.chevron_right, color: Colors.grey),
                    onPressed: () {
                      print('${item.path}/${item.title}.${item.ext}, 가수: ${item.artist}, 앨범: ${item.album}');
                      Map<String, String> data = {
                        'title' : item.title,
                        'artist' : item.artist,
                        'album' : item.album,
                        'path' : item.path,
                        'ext' : item.ext,
                        'albumArt' : item.albumArt
                      };
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoBox(data : data, type: 'M',))
                      );
                    },
                  ),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
