import 'package:flutter/material.dart';
import 'package:aml/components/custom_snackbar.dart';
import 'package:aml/constaints.dart';
// import 'package:aml/model/simple_album_model.dart';
import 'package:aml/stores/album_store.dart';
import 'package:aml/stores/main_store.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../access_info/app_access_info.dart';

class SimpleAlbumListTile extends StatefulWidget {
  const SimpleAlbumListTile({Key? key, required this.dateTime, required this.index}) : super(key: key);
  final String dateTime;
  final int index;

  @override
  State<SimpleAlbumListTile> createState() => _SimpleAlbumListTileState();
}

class _SimpleAlbumListTileState extends State<SimpleAlbumListTile> {
  TextEditingController artistInput = TextEditingController();
  TextEditingController groupInput = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    initText();
    super.initState();
  }

  initText() {
    setState(() {
      artistInput.text = '';
      groupInput.text = '';
    });
  }

  changeFormatDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  addAlbumData(bodyData) async {
    if(!await context.read<AlbumStore>().submit(bodyData)) {
      print('HTTP 통신에서 오류가 발생했습니다.');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var width = context.watch<MainStore>().deviceWidth;
    // List<SimpleAlbumModel> dataList = context.watch<AlbumStore>().simpleAblumData;
    String today = changeFormatDateTime();
    // int index = widget.index;

    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        setState(() {
          context.read<AlbumStore>().simpleAblumData[index].isExpanded = !isExpanded;
        });
      },
      children: context.watch<AlbumStore>().simpleAblumData.map<ExpansionPanel>((item) {
        return ExpansionPanel(
          backgroundColor: listTileBgColor,
          headerBuilder: (context, isExpanded) {
            return ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 20,
                      padding: EdgeInsets.zero,
                      child: Text(item.category),
                    ),
                    Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: isExpanded ? 4 : 1,
                            text: TextSpan(
                              text: item.title,
                              style: (width > 400) ? Theme.of(context).textTheme.bodyText1 : Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        )
                    )
                  ],
                )
            );
          },
          body: ListTile(
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            title: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: TextFormField(
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return '* 가수를 입력해야 합니다.';
                        }
                        return null;
                      },
                      controller: artistInput,
                      decoration: InputDecoration(
                          icon: Icon(Icons.mic),
                          labelText: '가수',
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: TextFormField(
                      validator: (val) {
                        if(val == null || val.isEmpty) {
                          return '* 그룹을 입력해야 합니다.';
                        }
                        return null;
                      },
                      controller: groupInput,
                      decoration: InputDecoration(
                          icon: Icon(Icons.group),
                          labelText: '그룹',
                          filled: true,
                          fillColor: Colors.white70,
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            trailing: ElevatedButton(
              child: Text('추가'),
              onPressed: () async {
                Map<String, String> bodyData = {
                  'released' : (widget.dateTime == '') ? today : widget.dateTime,
                  'title' : item.title,
                  'artist' : artistInput.text,
                  'artistGroup' : groupInput.text,
                  'albumArt' : defaultAlbumArtUrl,
                };
                if(formKey.currentState!.validate()) {
                  if(!await addAlbumData(bodyData)) {
                    CustomSnackbar.snackbar(context, '앨범 정보 등록 실패', 'warning');
                    print('데이터 등록 실패');
                    return;
                  }
                  initText();
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                  CustomSnackbar.snackbar(context, '앨범 정보 등록 성공', 'normal');
                  print('데이터 등록 성공');
                }
              },
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
