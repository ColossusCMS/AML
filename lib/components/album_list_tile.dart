import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:aml/stores/album_store.dart';
import 'package:aml/stores/main_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../access_info/app_access_info.dart';
import '../constaints.dart';
import '../pages/info_box.dart';

class AlbumListTile extends StatefulWidget {
  const AlbumListTile({Key? key}) : super(key: key);

  @override
  State<AlbumListTile> createState() => _AlbumListTileState();
}

class _AlbumListTileState extends State<AlbumListTile> {
  @override
  Widget build(BuildContext context) {
    var width = context.watch<MainStore>().deviceWidth;

    linkurl(item) async {
      String url = '$itemLinkUrl${item.title}';
      if(await launchUrl(Uri.parse(url))) {
        print(url);
      } else {
        print('주소가 잘못된 거 같은데');
      }
    }

    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          context.read<AlbumStore>().albumData[index].isExpanded = !isExpanded;
        });
      },
      children: context.watch<AlbumStore>().albumData.map<ExpansionPanel>((item) {
        return ExpansionPanel(
          backgroundColor: listTileBgColor,
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: (isExpanded == false) ?
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(item.released),
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.loose,
                    child: SizedBox(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                            text: item.title,
                            style: (width > 400) ? Theme.of(context).textTheme.bodyText1 : Theme.of(context).textTheme.bodyText2,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                linkurl(item);
                              }
                        ),
                      ),
                    ),
                  )
                ],
              ) : SizedBox(
                child: RichText(
                  text: TextSpan(
                      text: item.title,
                      style: (width > 400) ? Theme.of(context).textTheme.bodyText1 : Theme.of(context).textTheme.bodyText2,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          linkurl(item);
                        }
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
                Container(
                  width: 100,
                  height: 100,
                  padding: EdgeInsets.zero,
                  child: Image.network(
                    item.albumArt,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(defaultAlbumArtUrl, width: 100, height: 100, fit: BoxFit.cover,);
                    },
                  ),
                ),
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: (width > 400) ? '발매일 : ' : 'R: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black
                                      )
                                  ),
                                  TextSpan(
                                      text: item.released,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )
                                  )
                                ]
                            )
                        ),
                        RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: (width > 400) ? '가수명 : ' : 'A: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black
                                    )
                                ),
                                TextSpan(
                                    text: item.artist,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ]
                          ),
                        ),
                        RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              children: [
                                TextSpan(
                                    text: (width > 400) ? '소속명 : ' : 'G: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black
                                    )
                                ),
                                TextSpan(
                                    text: item.artistGroup,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.grey,),
              onPressed: () {
                print('[DEBUG]item.id : ${item.id}, item.released : ${item.released}, item.title : ${item.title}, '
                    // 'item.title_song : ${item.titleSong}, '
                    'item.artist : ${item.artist}, item.artistGroup : ${item.artistGroup}, item.albumArt : ${item.albumArt}');
                Map<String, String> bodyData = {
                  'id' : item.id.toString(),
                  'released' : item.released,
                  'title' : item.title,
                  'artist' : item.artist,
                  'artistGroup' : item.artistGroup,
                  'albumArt' : item.albumArt,
                };
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InfoBox(data: bodyData, type: 'A',)
                      // AlbumInfo(bodyData: bodyData)
                    )
                );
              },
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}